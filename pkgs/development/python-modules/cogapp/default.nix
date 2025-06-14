{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cogapp";
  version = "3.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8ZDEoPBLs4kyCmaLxxsTsLiGwKoc+o56lb1++RLg47E=";
  };

  build-system = [ setuptools ];

  # there are no tests
  doCheck = false;

  meta = {
    description = "Code generator for executing Python snippets in source files";
    homepage = "https://nedbatchelder.com/code/cog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovek323 ];
  };
}
