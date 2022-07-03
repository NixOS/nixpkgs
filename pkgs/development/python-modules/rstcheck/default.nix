{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, types-docutils
, typing-extensions
}:

buildPythonPackage rec {
  pname = "rstcheck";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "myint";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vTUa/eP6/flxRLBuzdHoNoPoGAg6XWwu922az8tLgJM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    docutils
    types-docutils
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rstcheck"
  ];

  preCheck = ''
    # The tests need to find and call the rstcheck executable
    export PATH="$PATH:$out/bin";
  '';

  meta = with lib; {
    description = "Checks syntax of reStructuredText and code blocks nested within it";
    homepage = "https://github.com/myint/rstcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ staccato ];
  };
}
