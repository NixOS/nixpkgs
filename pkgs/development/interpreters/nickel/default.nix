{ lib
, rustPlatform
, fetchFromGitHub
, python3
, nix-update-script
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-bG0vNfKQpFQHDBfokvTpfXgVmKg6u/BcIz139pLwwsE=";
  };

  cargoHash = "sha256-qPKAozFXv94wgY99ugjsSuaN92SXZGgZwI2+7UlerHQ=";

  cargoBuildFlags = [ "-p nickel-lang-cli" ];

  nativeBuildInputs = [
    python3
  ];

  # Disable checks on Darwin because of issue described in https://github.com/tweag/nickel/pull/1454
  doCheck = !stdenv.isDarwin;

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
    maintainers = with maintainers; [ AndersonTorres felschr matthiasbeyer ];
  };
}
