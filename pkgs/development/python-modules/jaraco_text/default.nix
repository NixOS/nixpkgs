{ lib, buildPythonPackage, fetchPypi, pythonOlder
, importlib-resources
, jaraco_functools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ede4e9103443b62b3d1d193257dfb85aab7c69a6cef78a0887d64bb307a03bc3";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs =[ setuptools-scm ];
  propagatedBuildInputs = [
    jaraco_functools
  ] ++ lib.optional (pythonOlder "3.7") [ importlib-resources ];

  # no tests in pypi package
  doCheck = false;

  meta = with lib; {
    description = "Module for text manipulation";
    homepage = "https://github.com/jaraco/jaraco.text";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

}
