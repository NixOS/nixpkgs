{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  toml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "scikit-base";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sktime";
    repo = "skbase";
    tag = "v${version}";
    hash = "sha256-taDnQFqLZbLbP3lEREqINUj026Y8Hi/hQkV9qslqKe4=";
  };

  build-system = [ setuptools ];

  dependencies = [ toml ];

  pythonImportsCheck = [ "skbase" ];

  meta = {
    description = "Base classes for creating scikit-learn-like parametric objects, and tools for working with them";
    homepage = "https://github.com/sktime/skbase";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kirillrdy ];
  };
}
