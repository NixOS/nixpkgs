{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hypothesis,
  python,
}:

buildPythonPackage rec {
  pname = "commonmark";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "commonmark.py";
    tag = version;
    hash = "sha256-Ui/G/VLdjWcm7YmVjZ5Q8h0DEEFqdDByre29g3zHUq4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ hypothesis ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} commonmark/tests/run_spec_tests.py
    ${python.interpreter} commonmark/tests/unit_tests.py

    export PATH=$out/bin:$PATH
    cmark commonmark/tests/test.md
    cmark commonmark/tests/test.md -a
    cmark commonmark/tests/test.md -aj

    runHook postCheck
  '';

  meta = with lib; {
    description = "Python CommonMark parser ";
    mainProgram = "cmark";
    homepage = "https://github.com/readthedocs/commonmark.py";
    license = licenses.bsd3;
  };
}
