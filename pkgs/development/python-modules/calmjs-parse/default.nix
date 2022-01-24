{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, ply
, python
}:

buildPythonPackage rec {
  pname = "calmjs-parse";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "calmjs";
    repo = "calmjs.parse";
    rev = version;
    sha256 = "0ypfbas33k1706p6w1bf9gnrv38z8fa4qci1iaks80dp58g8sv4r";
  };

  propagatedBuildInputs = [
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
    description = "Various parsers for ECMA standards";
    homepage = "https://github.com/calmjs/calmjs.parse";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
