{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, regex
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1ggvlzpdzlrxl46fgi8cfq2rzlwn21shpdkm4pknnhfjlsinv913";
  };

  # Optional import, but fixes some re known bugs & allows advanced regex features
  propagatedBuildInputs = [ regex ];

  checkPhase = ''
    runHook preCheck

    # Official way to run the tests. Runs unittest internally.
    # pytest produces issues with some test resource paths (relies on __main__)
    ${python.interpreter} -m tests

    runHook postCheck
  '';

  meta = with lib; {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = "https://lark-parser.readthedocs.io/";
    changelog = "https://github.com/lark-parser/lark/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fridh drewrisinger ];
  };
}
