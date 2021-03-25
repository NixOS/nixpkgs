{ lib
, buildPythonPackage
, fetchPypi
, numpy
, cython
}:

buildPythonPackage rec {
  pname = "pyworld";
  version = "0.2.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "896c910696975855578d855f490f94d7a57119e0a75f7f15e11fdf58ba891627";
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
    homepage = https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
