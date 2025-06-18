{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
  zstd-c,
}:

buildPythonPackage rec {
  pname = "pyzstd";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rogdham";
    repo = "pyzstd";
    tag = version;
    hash = "sha256-PICYdB/xu/q2wjbkF2nziZt8z8PmzJ5eM+Yq0rpLfEU=";
  };

  postPatch = ''
    # pyzst specifies setuptools<74 because 74+ drops `distutils.msvc9compiler`,
    # required for Python 3.9 under Windows
    substituteInPlace pyproject.toml \
        --replace-fail '"setuptools>=64,<74"' '"setuptools"'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  build-system = [
    setuptools
  ];

  dependencies = lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  pythonRelaxDeps = [
    "typing-extensions"
  ];

  buildInputs = [
    zstd-c
  ];

  pypaBuildFlags = [
    "--config-setting=--global-option=--dynamic-link-zstd"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyzstd"
  ];

  meta = {
    description = "Python bindings to Zstandard (zstd) compression library";
    homepage = "https://pyzstd.readthedocs.io";
    changelog = "https://github.com/Rogdham/pyzstd/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      MattSturgeon
      pitkling
      PopeRigby
    ];
  };
}
