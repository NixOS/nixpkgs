{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  standard-cgi,
}:

buildPythonPackage rec {
  pname = "htmlmin";
  version = "0.1.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UMHvRjA3Sl1yOQAJapYc/0Jt/0a0jzTRlKgbvhTsoXg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    standard-cgi
  ];

  # pypi tarball does not contain tests
  doCheck = false;

  meta = {
    description = "Configurable HTML Minifier with safety features";
    mainProgram = "htmlmin";
    homepage = "https://github.com/mankyd/htmlmin";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
