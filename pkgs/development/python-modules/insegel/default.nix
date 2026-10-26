{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
}:

buildPythonPackage (finalAttrs: {
  pname = "insegel";
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HQVd1k9uszVYCkhScVEbovTjteMV9I+Cf1jaPKzktK4=";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "insegel" ];

  meta = {
    homepage = "https://github.com/autophagy/insegel";
    description = "Monochrome 2 column Sphinx theme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ autophagy ];
  };
})
