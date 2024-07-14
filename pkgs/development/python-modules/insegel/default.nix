{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
}:

buildPythonPackage rec {
  pname = "insegel";
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HQVd1k9uszVYCkhScVEbovTjteMV9I+Cf1jaPKzktK4=";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "insegel" ];

  meta = with lib; {
    homepage = "https://github.com/autophagy/insegel";
    description = "Monochrome 2 column Sphinx theme";
    license = licenses.mit;
    maintainers = with maintainers; [ autophagy ];
  };
}
