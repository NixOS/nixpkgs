<<<<<<< HEAD
{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, numpy
, cython
, zlib
, python-lzo
, nose
}:

buildPythonPackage rec {
  pname = "bx-python";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, numpy, cython, zlib, six
, python-lzo, nose }:

buildPythonPackage rec {
  pname = "bx-python";
  version = "0.9.0";
  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bxlab";
    repo = "bx-python";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-j2GKj2IGDBk4LBnISRx6ZW/lh5VSdQBasC0gCRj0Fiw=";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    numpy
    python-lzo
  ];

  nativeCheckInputs = [
    nose
  ];
=======
    hash = "sha256-Pi4hV3FatCXoXY3nNgqm5UfWYIrpP/v5PzzCi3gmIbE=";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ zlib ];
  propagatedBuildInputs = [ numpy six python-lzo ];
  nativeCheckInputs = [ nose ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    cp -r scripts/* $out/bin

<<<<<<< HEAD
    # This is a small hack; the test suite uses the scripts which need to
=======
    # This is a small hack; the test suit uses the scripts which need to
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # be patched. Linking the patched scripts in $out back to the
    # working directory allows the tests to run
    rm -rf scripts
    ln -s $out/bin scripts
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Tools for manipulating biological data, particularly multiple sequence alignments";
    homepage = "https://github.com/bxlab/bx-python";
    changelog = "https://github.com/bxlab/bx-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jbedo ];
=======
    homepage = "https://github.com/bxlab/bx-python";
    description =
      "Tools for manipulating biological data, particularly multiple sequence alignments";
    license = licenses.mit;
    maintainers = [ maintainers.jbedo ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" ];
  };
}
