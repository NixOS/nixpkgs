{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  erlang,
  makeWrapper,
  nix-update-script,
  coreutils,
  curl,
  bash,
  debugInfo ? false,
}@inputs:

{
  baseName ? "elixir",
  version,
  erlang ? inputs.erlang,
  minimumOTPVersion,
  maximumOTPVersion ? null,
  sha256 ? null,
  rev ? "v${version}",
  src ? fetchFromGitHub {
    inherit rev sha256;
    owner = "elixir-lang";
    repo = "elixir";
  },
  escriptPath ? "lib/elixir/generate_app.escript",
}@args:

let
  inherit (lib)
    assertMsg
    concatStringsSep
    getVersion
    optionals
    optionalString
    toInt
    versions
    versionAtLeast
    versionOlder
    ;

  compatibilityMsg = ''
    Unsupported elixir and erlang OTP combination.

    elixir ${version}
    erlang OTP ${getVersion erlang} is not >= ${minimumOTPVersion} ${
      optionalString (maximumOTPVersion != null) "and <= ${maximumOTPVersion}"
    }

    See https://hexdocs.pm/elixir/${version}/compatibility-and-deprecations.html
  '';

  maxShiftMajor = builtins.toString ((toInt (versions.major maximumOTPVersion)) + 1);
  maxAssert =
    if (maximumOTPVersion == null) then
      true
    else
      versionOlder (versions.major (getVersion erlang)) maxShiftMajor;
  minAssert = versionAtLeast (getVersion erlang) minimumOTPVersion;
  bothAssert = minAssert && maxAssert;

  elixirShebang =
    if stdenv.hostPlatform.isDarwin then
      # Darwin disallows shebang scripts from using other scripts as their
      # command. Use env as an intermediary instead of calling elixir directly
      # (another shebang script).
      # See https://github.com/NixOS/nixpkgs/pull/9671
      "${coreutils}/bin/env $out/bin/elixir"
    else
      "$out/bin/elixir";

  erlc_opts = [ "deterministic" ] ++ optionals debugInfo [ "debug_info" ];
in
if !config.allowAliases && !bothAssert then
  # Don't throw without aliases to not break CI.
  null
else
  assert assertMsg bothAssert compatibilityMsg;
  stdenv.mkDerivation {
    pname = "${baseName}";

    inherit src version debugInfo;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ erlang ];

    env = {
      LANG = "C.UTF-8";
      LC_TYPE = "C.UTF-8";
      DESTDIR = placeholder "out";
      PREFIX = "/";
      ERL_COMPILER_OPTIONS = "[${concatStringsSep "," erlc_opts}]";
    };

    preBuild = ''
      patchShebangs ${escriptPath} || true
    '';

    # copy stdlib source files for LSP access
    postInstall = ''
      for d in lib/*; do
        cp -R "$d/lib" "$out/lib/elixir/$d"
      done
    '';

    postFixup = ''
      # Elixir binaries are shell scripts which run erl. Add some stuff
      # to PATH so the scripts can run without problems.

      for f in $out/bin/*; do
        b=$(basename $f)
        if [ "$b" = mix ]; then continue; fi
        wrapProgram $f \
          --prefix PATH ":" "${
            lib.makeBinPath [
              erlang
              coreutils
              curl
              bash
            ]
          }"
      done

      substituteInPlace $out/bin/mix \
        --replace "/usr/bin/env elixir" "${elixirShebang}"
    '';

    passthru.updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(${lib.versions.major version}\\.${lib.versions.minor version}\\.[0-9\\-rc.]+)"
        "--override-filename"
        "pkgs/development/interpreters/elixir/${lib.versions.major version}.${lib.versions.minor version}.nix"
      ];
    };

    pos = builtins.unsafeGetAttrPos "sha256" args;
    meta = with lib; {
      homepage = "https://elixir-lang.org/";
      description = "Functional, meta-programming aware language built on top of the Erlang VM";

      longDescription = ''
        Elixir is a functional, meta-programming aware language built on
        top of the Erlang VM. It is a dynamic language with flexible
        syntax and macro support that leverages Erlang's abilities to
        build concurrent, distributed and fault-tolerant applications
        with hot code upgrades.
      '';

      license = licenses.asl20;
      platforms = platforms.unix;
      teams = [ teams.beam ];
    };
  }
