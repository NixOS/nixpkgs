{
  lib,
  buildPythonPackage,
  configupdater,
  distutils,
  fetchFromGitHub,
  nix-update-script,
  packaging,
  pytest-cov-stub,
  pytest-randomly,
  pytest-xdist,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  tomli-w,
  tomli,
  tomlkit,
  validate-pyproject,
}:

buildPythonPackage (finalAttrs: {
  pname = "ini2toml";
  version = "0.16";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abravalheri";
    repo = "ini2toml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z3Lnq0O6FeG0n/YwPbCVrMQOJYTDuNN4UO1WBGJkb9k=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    distutils
    packaging
    setuptools
  ];

  optional-dependencies = {
    all = [
      configupdater
      tomli-w
      tomlkit
    ];
    full = [
      configupdater
      tomlkit
    ];
    lite = [ tomli-w ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-randomly
    pytest-xdist
    pytestCheckHook
    setuptools
    tomli
    validate-pyproject
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "ini2toml" ];

  disabledTests =
    let
      examples = [
        "tests/examples/setuptools_docs/setup.cfg-tests/examples/setuptools_docs/pyproject.toml"
        "tests/examples/flask/setup.cfg-tests/examples/flask/pyproject.toml"
        "tests/examples/django/setup.cfg-tests/examples/django/pyproject.toml"
        "tests/examples/setuptools_scm/setup.cfg-tests/examples/setuptools_scm/pyproject.toml"
        "tests/examples/pluggy/setup.cfg-tests/examples/pluggy/pyproject.toml"
        "tests/examples/virtualenv/setup.cfg-tests/examples/virtualenv/pyproject.toml"
        "tests/examples/pyscaffold/setup.cfg-tests/examples/pyscaffold/pyproject.toml"
        "tests/examples/plumbum/setup.cfg-tests/examples/plumbum/pyproject.toml"
        "tests/examples/pandas/setup.cfg-tests/examples/pandas/pyproject.toml"
      ];
    in
    [
      "test_handle_license"
      "test_handle_license_and_files"
    ]
    ++ lib.concatMap (example: [
      "test_examples_api[${example}]"
      "test_examples_cli[${example}]"
    ]) examples;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatically conversion of .ini/.cfg files to TOML equivalents";
    homepage = "https://github.com/abravalheri/ini2toml";
    changelog = "https://github.com/abravalheri/ini2toml/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
