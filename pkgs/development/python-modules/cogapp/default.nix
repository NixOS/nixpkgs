{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cogapp";
  version = "3.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qAbV254xihotP86YgAgXkWjn2xPl5VsZt5dj+budKYI=";
  };

  nativeBuildInputs = [ setuptools ];

  # there are no tests
  doCheck = false;

  meta = with lib; {
    description = "A code generator for executing Python snippets in source files";
    homepage = "https://nedbatchelder.com/code/cog";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
  };
}
