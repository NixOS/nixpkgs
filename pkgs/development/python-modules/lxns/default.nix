{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  meson-python,
}:

buildPythonPackage rec {
  pname = "lxns";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igo95862";
    repo = "python-lxns";
    rev = version;
    hash = "sha256-O7B2Do+b70i00HDxWgIV1yuNIx5lmpoZmHeA6yS2nLY=";
  };

  build-system = [
    meson-python
  ];

  pythonImportsCheck = [
    "lxns"
  ];

  meta = {
    description = "Python library to control Linux kernel namespaces";
    homepage = "https://github.com/igo95862/python-lxns";
    changelog = "https://github.com/igo95862/python-lxns/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      mpl20
    ];
    maintainers = with lib.maintainers; [ justdeeevin ];
  };
}
