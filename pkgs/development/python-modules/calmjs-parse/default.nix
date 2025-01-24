{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ply,
  python,
}:

buildPythonPackage rec {
  pname = "calmjs-parse";
  version = "1.3.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "calmjs";
    repo = "calmjs.parse";
    rev = version;
    hash = "sha256-+tel9AJFaKqsuSjqS1KPyRjO6iU7V90ECSEYLBdfqZU=";
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

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m unittest calmjs.parse.tests.make_suite

    runHook postCheck
  '';

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
