{ stdenv
, lib
, buildPythonPackage
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, fonttools
, pytestCheckHook
, setuptools-scm
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "cffsubr";
  version = "0.2.9.post1";
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-azFBLc9JyPqEZkvahn4u3cVbb+b6aW/yU8TxOp/y/Fw=";
  };

  patches = [
    # https://github.com/adobe-type-tools/cffsubr/pull/23
    (fetchpatch {
      name = "remove-setuptools-git-ls-files.patch";
      url = "https://github.com/adobe-type-tools/cffsubr/commit/887a6a03b1e944b82fcb99b797fbc2f3a64298f0.patch";
      hash = "sha256-LuyqBtDrKWwCeckr+YafZ5nfVw1XnELwFI6X8bGomhs=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    wheel
=======
    sha256 = "azFBLc9JyPqEZkvahn4u3cVbb+b6aW/yU8TxOp/y/Fw=";
  };

  nativeBuildInputs = [
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    fonttools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cffsubr" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Standalone CFF subroutinizer based on AFDKO tx";
    homepage = "https://github.com/adobe-type-tools/cffsubr";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ jtojnar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
