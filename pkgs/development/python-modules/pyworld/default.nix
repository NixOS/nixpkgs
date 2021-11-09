{ lib
, buildPythonPackage
, fetchPypi
, numpy
, cython
}:

buildPythonPackage rec {
  pname = "pyworld";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e19b5d8445e0c4fc45ded71863aeaaf2680064b4626b0e7c90f72e9ace9f6b5b";
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
