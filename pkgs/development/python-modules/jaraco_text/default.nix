{ lib, buildPythonPackage, fetchPypi, pythonOlder
, importlib-resources
, jaraco_functools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "901d3468eaaa04f1d8a8f141f54b8887bfd943ccba311fc1c1de62c66604dfe0";
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
