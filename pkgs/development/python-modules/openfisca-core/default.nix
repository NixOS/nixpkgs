{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  dpath,
  flask,
  flask-cors,
  gunicorn,
  numexpr,
  numpy,
  pendulum,
  psutil,
  pytest,
  strenum,
  sortedcontainers,
  typing-extensions,
  pytestCheckHook,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "openfisca-core";
  version = "43.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openfisca";
    repo = "openfisca-core";
    tag = finalAttrs.version;
    hash = "sha256-5eMtgmuxMpOf41A5ohzwMhv5hzAnbQTmf7QSmDUniZg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    dpath
    numexpr
    numpy
    pendulum
    psutil
    pytest
    strenum
    sortedcontainers
    typing-extensions
  ];

  optional-dependencies = {
    web-api = [
      flask
      flask-cors
      gunicorn
      werkzeug
    ];
  };

  pythonRelaxDeps = [
    "numpy"
    "psutil"
    "pytest"
  ];

  pythonImportsCheck = [
    "openfisca_core"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.optional-dependencies.web-api;

  # Circular dependency with openfisca-country-template
  doCheck = false;

  meta = {
    description = "OpenFisca core engine. See other repositories for countries-specific code & data";
    homepage = "https://github.com/openfisca/openfisca-core";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
