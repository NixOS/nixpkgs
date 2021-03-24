{ lib, buildPythonPackage, fetchPypi, pythonOlder
, importlib-resources
, jaraco_functools
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f07f1076814a17a98eb915948b9a0dc71b1891c833588066ec1feb04ea4389b1";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs =[ setuptools_scm ];
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
