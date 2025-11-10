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

buildPythonPackage rec {
  pname = "openfisca-core";
  version = "43.4.3-unstable-2025-11-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openfisca";
    repo = "openfisca-core";
    rev = "c0b255fb539eb9bcdea5b2a07d968f4aac39587a";
    hash = "sha256-6V+kr0Vo3LMlkzngbHcZs889nBJMaxqj2wRmfbb+4GY=";
  };

  # TODO: submit upstream and remove when fixed
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'openfisca_core/i18n/fr/LC_MESSAGES/openfisca-core.mo' 'openfisca_core/i18n/fr/LC_MESSAGES/openfisca-core.po'
  '';

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
  ];

  pythonImportsCheck = [
    "openfisca_core"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.web-api;

  # Need help to fix this !
  # Circular dependency with openfisca-country-template
  doCheck = false;

  meta = {
    description = "OpenFisca core engine. See other repositories for countries-specific code & data";
    homepage = "https://github.com/openfisca/openfisca-core";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
