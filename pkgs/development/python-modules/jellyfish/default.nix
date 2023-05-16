{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, unicodecsv
<<<<<<< HEAD
, rustPlatform
, libiconv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jellyfish";
<<<<<<< HEAD
  version = "1.0.0";

  disabled = !isPy3k;

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iBquNnGZm7B85QwnaW8pyn6ELz4SOswNtlJcmZmIG9Q=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-rust-dependencies";
    hash = "sha256-Grk+n4VCPjirafcRWWI51jHw/IFUYkBtbXY739j0MFI=";
=======
  version = "0.9.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "40c9a2ffd8bd3016f7611d424120442f627f56d518a106847dc93f0ead6ad79a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [ pytest unicodecsv ];

  meta = {
    homepage = "https://github.com/sunlightlabs/jellyfish";
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
