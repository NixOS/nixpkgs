{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "1.0.0";

  src  = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "refs/tags/${version}"; # because pure ${version} doesn't work
    hash = "sha256-8peoO3B5LHKiTUyDLpe0A2xg82LPI7l2vuGdyNhV478=";
  };

  cargoHash = "sha256-lrRCc5kUekUHrJTznR8xRiLVgQLJ/PsMP967PS41UJU=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://nickel-lang.org/";
    description = "Better configuration for less";
    longDescription = ''
      Nickel is the cheap configuration language.

      Its purpose is to automate the generation of static configuration files -
      think JSON, YAML, XML, or your favorite data representation language -
      that are then fed to another system. It is designed to have a simple,
      well-understood core: it is in essence JSON with functions.
    '';
    changelog = "https://github.com/tweag/nickel/blob/${version}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres felschr ];
  };
}
