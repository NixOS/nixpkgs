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
  version = "1.3.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "calmjs";
    repo = "calmjs.parse";
    tag = version;
    hash = "sha256-aGGIwQBHToujc69zzIeEbvmYwLKA5X3bamVWBRmJtSE=";
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

  meta = with lib; {
    changelog = "https://github.com/calmjs/calmjs.parse/blob/${src.rev}/CHANGES.rst";
    description = "Various parsers for ECMA standards";
    homepage = "https://github.com/calmjs/calmjs.parse";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
