{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
, python
}:

buildPythonPackage rec {
  pname = "Bottleneck";
  name = "Bottleneck-${version}";
  version = "1.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "3bec84564a4adbe97c24e875749b949a19cfba4e4588be495cc441db7c6b05e8";
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