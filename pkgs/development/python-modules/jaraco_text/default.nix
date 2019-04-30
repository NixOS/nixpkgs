{ buildPythonPackage, fetchPypi, setuptools_scm
, jaraco_functools
}:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1l5hq2jvz9xj05aayc42f85v8wx8rpi16lxph8blw51wgnvymsyx";
  };
  doCheck = false;
  buildInputs =[ setuptools_scm ];
  propagatedBuildInputs = [ jaraco_functools ];
}
