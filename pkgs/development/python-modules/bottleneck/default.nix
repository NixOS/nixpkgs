{ buildPythonPackage
, fetchPypi
, nose
, pytest
, numpy
, python
}:

buildPythonPackage rec {
  pname = "Bottleneck";
  version = "1.2.1";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6efcde5f830aed64feafca0359b51db0e184c72af8ba6675b4a99f263922eb36";
  };

  checkInputs = [ pytest nose ];
  propagatedBuildInputs = [ numpy ];
  checkPhase = ''
    py.test -p no:warnings $out/${python.sitePackages}
  '';
  postPatch = ''
    substituteInPlace setup.py --replace "__builtins__.__NUMPY_SETUP__ = False" ""
  '';
}
