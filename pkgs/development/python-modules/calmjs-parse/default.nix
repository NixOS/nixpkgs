{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ply,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "calmjs-parse";
  version = "1.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "calmjs";
    repo = "calmjs.parse";
    tag = version;
    hash = "sha256-OX3031omx9PdrVeNbekWzJKrrrKleP7q7yDosKsvH8U=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "env['PYTHONPATH'] = 'src'" "env['PYTHONPATH'] += ':src'"
  '';

  build-system = [ setuptools ];

  dependencies = [
    setuptools
    ply
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "calmjs.parse"
    "calmjs.parse.asttypes"
    "calmjs.parse.parsers"
    "calmjs.parse.rules"
    "calmjs.parse.sourcemap"
    "calmjs.parse.unparsers.es5"
    "calmjs.parse.walkers"
  ];

  meta = {
    changelog = "https://github.com/calmjs/calmjs.parse/blob/${src.tag}/CHANGES.rst";
    description = "Various parsers for ECMA standards";
    homepage = "https://github.com/calmjs/calmjs.parse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
