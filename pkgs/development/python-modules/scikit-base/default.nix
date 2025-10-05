{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  toml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "scikit-base";
  version = "0.12.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sktime";
    repo = "skbase";
    tag = "v${version}";
    hash = "sha256-c9hQBZV+PWI6ZViocUYqryhvDg0nJ6Qxdx6zwIV0fes=";
  };

  build-system = [ setuptools ];

  dependencies = [ toml ];

  pythonImportsCheck = [ "skbase" ];

  meta = with lib; {
    description = "Base classes for creating scikit-learn-like parametric objects, and tools for working with them";
    homepage = "https://github.com/sktime/skbase";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirillrdy ];
  };
}
