{ buildPythonPackage
, fetchPypi
, nose
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

  checkInputs = [ nose ];
  propagatedBuildInputs = [ numpy ];
  checkPhase = ''
    nosetests -v $out/${python.sitePackages}
  '';
  postPatch = ''
    substituteInPlace setup.py --replace "__builtins__.__NUMPY_SETUP__ = False" ""
  '';
}
