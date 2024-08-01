{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
  packaging,
}:

buildPythonPackage rec {
  pname = "pallets-sphinx-themes";
  version = "2.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "pallets-sphinx-themes";
    rev = "refs/tags/${version}";
    sha256 = "sha256-uXSejJLVmYpzRCP92JQKHosnlx7dgZlFf5XzbxOfvII=";
  };

  propagatedBuildInputs = [
    packaging
    sphinx
  ];

  pythonImportsCheck = [ "pallets_sphinx_themes" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pallets/pallets-sphinx-themes";
    description = "Sphinx theme for Pallets projects";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
