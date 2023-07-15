{ lib
, buildPythonPackage
, fetchPypi
, numpy
, cython
}:

buildPythonPackage rec {
  pname = "pyworld";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o6gXVZg9+iKZqeKUd1JYLdzISlwnewT0WVzkQGNy0eU=";
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
