{ lib, buildPythonPackage, fetchPypi
, nose
, numpy
, pytest
, python
}:

buildPythonPackage rec {
  pname = "Bottleneck";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20179f0b66359792ea283b69aa16366419132f3b6cf3adadc0c48e2e8118e573";
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
