{ lib
, buildPythonPackage
<<<<<<< HEAD
, cython
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, setuptools-scm
, fonttools
, pytestCheckHook
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "compreffor";
<<<<<<< HEAD
  version = "0.5.4";
=======
  version = "0.5.3";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-MGulQEUGPrQ30T3VYzwRRlvzvWkFqNzqsNzAjtjX9xU=";
  };

  patches = [
    # https://github.com/googlefonts/compreffor/pull/153
    (fetchpatch {
      name = "remove-setuptools-git-ls-files.patch";
      url = "https://github.com/googlefonts/compreffor/commit/10f563564390568febb3ed1d0f293371cbd86953.patch";
      hash = "sha256-wNQMJFJXTFILGzAgzUXzz/rnK67/RU+exYP6MhEQAkA=";
    })
  ];

  nativeBuildInputs = [
    cython
    setuptools-scm
    wheel
=======
    hash = "sha256-fUEpbU+wqh72lt/ZJdKvMifUAwYivpmzx9QQfcb4cTo=";
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

  # Tests cannot seem to open the cpython module.
  doCheck = false;

  pythonImportsCheck = [
    "compreffor"
  ];

  meta = with lib; {
    description = "CFF table subroutinizer for FontTools";
    homepage = "https://github.com/googlefonts/compreffor";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ jtojnar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
