{ lib, buildPythonPackage, fetchPypi
, nose
, numpy
, pytest
, python
}:

buildPythonPackage rec {
  pname = "Bottleneck";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-F2Sn9K1YxVhyPFQoR+s2erC7ttiApOXV7vMKDs5c7Oo=";
  };

  propagatedBuildInputs = [ numpy ];

  postPatch = ''
    substituteInPlace setup.py --replace "__builtins__.__NUMPY_SETUP__ = False" ""
  '';

  checkInputs = [ pytest nose ];
  checkPhase = ''
    py.test -p no:warnings $out/${python.sitePackages}
  '';

  meta = with lib; {
    description = "Fast NumPy array functions written in C";
    homepage = "https://github.com/pydata/bottleneck";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
