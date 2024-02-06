{ lib
, fetchFromGitHub
, buildPythonPackage
, python
, graphviz
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gprof2dot";
  version = "2022.07.29";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "gprof2dot";
    rev = "refs/tags/${version}";
    hash = "sha256-nIsBO6KTyG2VZZRXrkU/T/a9Ki1x6hda5Vv3rZv/mJM=";
  };

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ graphviz ]}"
  ];

  # Needed so dot is on path of the test script
  nativeCheckInputs = [
    graphviz
  ];

  checkPhase = ''
    runHook preCheck

    # if options not specified, will use unwrapped gprof2dot from original source
    ${python.interpreter} tests/test.py --python bash --gprof2dot $out/bin/gprof2dot

    runHook postCheck
  '';

  meta = with lib; {
    description = "Python script to convert the output from many profilers into a dot graph";
    homepage = "https://github.com/jrfonseca/gprof2dot";
    changelog = "https://github.com/jrfonseca/gprof2dot/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
  };
}
