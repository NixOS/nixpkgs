{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, python3
, libiconv
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "1.1.1";

  src  = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-bG0vNfKQpFQHDBfokvTpfXgVmKg6u/BcIz139pLwwsE=";
  };

  cargoHash = "sha256-qPKAozFXv94wgY99ugjsSuaN92SXZGgZwI2+7UlerHQ=";

  cargoBuildFlags = [ "-p nickel-lang-cli" ];

  nativeBuildInputs = [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  buildInputs = [ ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

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
