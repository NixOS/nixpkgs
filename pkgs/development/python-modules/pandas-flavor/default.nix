{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  pytestCheckHook,
  setuptools,
  xarray,
}:

buildPythonPackage rec {
  pname = "pandas-flavor";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyjanitor-devs";
    repo = "pandas_flavor";
    tag = "v${version}";
    hash = "sha256-5DGXruQd6Dm9w2yI3pyi6KIei3nXhbWRmdY/XpeF1vA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pandas
    xarray
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "pandas_flavor"
  ];

  meta = {
    description = "The easy way to write your own flavor of Pandas";
    homepage = "https://github.com/pyjanitor-devs/pandas_flavor";
    changelog = "https://github.com/pyjanitor-devs/pandas_flavor/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
}
