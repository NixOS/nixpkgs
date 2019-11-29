{ buildPythonPackage, fetchPypi, setuptools_scm
, jaraco_functools
}:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "3.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0c7effed0f269e8bdae3374a7545763e84c1e7f9777cf2dd2d49eef92eb0d7b7";
  };
  doCheck = false;
  buildInputs =[ setuptools_scm ];
  propagatedBuildInputs = [ jaraco_functools ];
}
