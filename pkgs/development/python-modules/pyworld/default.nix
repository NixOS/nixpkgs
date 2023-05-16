{ lib
, buildPythonPackage
, fetchPypi
, numpy
, cython
}:

buildPythonPackage rec {
  pname = "pyworld";
<<<<<<< HEAD
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EGxw7np9jJukiNgCLyAzcGkppA8CZCVrjofaWquYMDo=";
=======
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zo0JhCw8+nSx9u2r2wBYpkwE+c8XuTiD5tqBHhIErU0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "pyworld" ];

  meta = with lib; {
    description = "PyWorld is a Python wrapper for WORLD vocoder";
    homepage = "https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
