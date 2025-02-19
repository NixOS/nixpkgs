{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  toml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "scikit-base";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sktime";
    repo = "skbase";
    tag = "v${version}";
    hash = "sha256-UGYkYhgo6LzlZTg6YDehJXd4D5p8FfUgWPdlW4PPOdI=";
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
