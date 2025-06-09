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

  nativeBuildInputs = [ setuptools ];

  # there are no tests
  doCheck = false;

  meta = with lib; {
    description = "Code generator for executing Python snippets in source files";
    homepage = "https://nedbatchelder.com/code/cog";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
  };
}
