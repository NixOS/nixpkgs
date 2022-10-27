{ lib
, buildPythonPackage
, fetchPypi
, numpy
, cython
}:

buildPythonPackage rec {
  pname = "pyworld";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ewx3JLrR4Ml8WbWGSEwApAM5wmJU+luro/TXhnIaX3E=";
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
