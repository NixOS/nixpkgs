{ lib, buildPythonPackage, fetchPypi
, nose
, numpy
, pytest
, python
}:

buildPythonPackage rec {
  pname = "Bottleneck";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a2a94zahl3kqld2n9dm58fvazz9s52sa16nd8yn5jv20hvqc5a5";
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
