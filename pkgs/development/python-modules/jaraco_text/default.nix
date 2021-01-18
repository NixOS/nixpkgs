{ lib, buildPythonPackage, fetchPypi, pythonOlder
, importlib-resources
, jaraco_functools
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v0hz3h74m31jlbc5bxwkvrx1h2n7887bajrg1n1c3yc4q8qn1z5";
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
