{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pylint
, pylint-plugin-utils
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, validators
}:
buildPythonPackage rec {
  pname = "pylint-odoo";
  version = "9.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "OCA";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DqW57W3ioxzkmsr7tOBd4g1NwdwYAtU2iSAzDo/S+wA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/OCA/pylint-odoo/pull/487.patch";
      sha256 = "sha256-B8pNpIUoYH2BDflWhjxJq0KY0qRLKbtkp455CEZWTao=";
    })
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "pylint-plugin-utils"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    pylint-plugin-utils
    validators
  ];

  pythonImportsCheck = [
    "pylint_odoo"
  ];

  meta = with lib; {
    description = "Odoo plugin for Pylint";
    homepage = "https://github.com/OCA/pylint-odoo";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ yajo ];
  };
}
