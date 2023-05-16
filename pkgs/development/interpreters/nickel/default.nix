{ lib
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
, python3
, nix-update-script
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
<<<<<<< HEAD
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
=======
  version = "0.3.1";

  src  = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "refs/tags/${version}"; # because pure ${version} doesn't work
    hash = "sha256-bUUQP7ze0j8d+VEckexDOferAgAHdKZbdKR3q0TNOeE=";
  };

  cargoSha256 = "sha256-E8eIUASjCIVsZhptbU41VfK8bFmA4FTT3LVagLrgUso=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ AndersonTorres felschr matthiasbeyer ];
=======
    maintainers = with maintainers; [ AndersonTorres ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
