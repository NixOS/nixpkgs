{ lib, openssl }:

{
  name = "openssl-${openssl.version}-certificate-discovery";

  nodes.machine = {
    security.pki.installCACerts = false;
    users.users.verifier.isNormalUser = true;
  };

  testScript = ''
    import shlex
    from enum import Enum

    class State(Enum):
        UNSET = "unset"
        MISSING = "missing"
        VALID = "valid"
        INVALID = "invalid"
        UNREADABLE = "unreadable"
        DANGLING = "dangling"
        EMPTY = "empty"

    start_all()

    system_bundle = "/etc/ssl/certs/ca-certificates.crt"
    profile_bundle = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
    authorities = ["system", "profile", "ssl", "nix"]

    machine.succeed("mkdir -p /tmp/certificates /etc/ssl/certs /nix/var/nix/profiles/default/etc/ssl/certs")
    for authority in authorities:
        machine.succeed(
            "${lib.getExe openssl} req -x509 -newkey rsa:2048 -noenc -days 1 "
            f"-subj /CN={authority} -keyout /tmp/certificates/{authority}.key "
            f"-out /tmp/certificates/{authority}.pem"
        )

    machine.succeed("printf 'invalid certificate bundle' > /tmp/certificates/invalid.pem")
    machine.succeed("install -m 000 /tmp/certificates/nix.pem /tmp/certificates/unreadable.pem")

    def set_bundle(path: str, state: State, authority: str):
        machine.succeed(f"rm -f {path}")
        match state:
            case State.MISSING:
                return
            case State.DANGLING:
                machine.succeed(f"ln -s /tmp/certificates/missing.pem {path}")
                return
            case State.VALID:
                source, mode = authority, "644"
            case State.INVALID:
                source, mode = "invalid", "644"
            case State.UNREADABLE:
                source, mode = authority, "000"
            case _:
                raise ValueError(f"Unsupported bundle state: {state}")

        machine.succeed(f"install -m {mode} /tmp/certificates/{source}.pem {path}")

    def check_trust(expected, overrides=None, explicit_bundle=None):
        environment = "env -u NIX_SSL_CERT_FILE -u SSL_CERT_FILE"
        for name, path in (overrides or {}).items():
            environment += " " + shlex.quote(f"{name}={path}")

        # Run without root privileges so unreadable bundles really are unreadable.
        command = (
            "runuser -u verifier -- " + environment +
            " ${lib.getExe openssl} verify -no-CApath -no-CAstore"
        )
        if explicit_bundle is not None:
            command += " -CAfile " + shlex.quote(explicit_bundle)

        for authority in authorities:
            verify = command + f" /tmp/certificates/{authority}.pem"
            if authority == expected:
                machine.succeed(verify)
            else:
                machine.fail(verify)

    states = [State.MISSING, State.VALID, State.INVALID, State.UNREADABLE, State.DANGLING]
    for system_state in states:
        for profile_state in states:
            with subtest(f"system={system_state.value}, profile={profile_state.value}"):
                set_bundle(system_bundle, system_state, "system")
                set_bundle(profile_bundle, profile_state, "profile")
                match system_state, profile_state:
                    case State.VALID, _:
                        expected = "system"
                    case State.MISSING | State.DANGLING, State.VALID:
                        expected = "profile"
                    case _:
                        expected = None
                check_trust(expected)

    set_bundle(system_bundle, State.VALID, "system")
    set_bundle(profile_bundle, State.VALID, "profile")

    def override_path(state: State, authority: str):
        match state:
            case State.VALID:
                return f"/tmp/certificates/{authority}.pem"
            case State.EMPTY:
                return ""
            case State.INVALID | State.MISSING | State.UNREADABLE:
                return f"/tmp/certificates/{state.value}.pem"
            case _:
                raise ValueError(f"Unsupported override state: {state}")

    # Explicit environment overrides must not fall back, even when unusable.
    override_states = [State.UNSET, State.VALID, State.INVALID, State.MISSING, State.UNREADABLE, State.EMPTY]
    for nix_state in override_states:
        for ssl_state in override_states:
            with subtest(f"NIX_SSL_CERT_FILE={nix_state.value}, SSL_CERT_FILE={ssl_state.value}"):
                overrides = {}
                if ssl_state is not State.UNSET:
                    overrides["SSL_CERT_FILE"] = override_path(ssl_state, "ssl")
                if nix_state is not State.UNSET:
                    overrides["NIX_SSL_CERT_FILE"] = override_path(nix_state, "nix")

                match nix_state, ssl_state:
                    case State.VALID, _:
                        expected = "nix"
                    case State.UNSET, State.VALID:
                        expected = "ssl"
                    case State.UNSET, State.UNSET:
                        expected = "system"
                    case _:
                        expected = None
                check_trust(expected, overrides)

    for state in [State.VALID, State.INVALID, State.MISSING, State.UNREADABLE, State.EMPTY]:
        with subtest(f"explicit CAfile={state.value} takes precedence over environment overrides"):
            match state:
                case State.VALID:
                    expected = "profile"
                case _:
                    expected = None
            check_trust(
                expected,
                {"NIX_SSL_CERT_FILE": "/tmp/certificates/nix.pem", "SSL_CERT_FILE": "/tmp/certificates/ssl.pem"},
                override_path(state, "profile"),
            )
  '';
}
