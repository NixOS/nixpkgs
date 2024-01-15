{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, astor
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flynt";
  version = "0.66";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ikamensh";
    repo = "flynt";
    rev = version;
    hash = "sha256-DV433wqLjF5k4g8J7rj5gZfaw+Y4/TDOoFKo3eKDjZ4=";
  };

  propagatedBuildInputs = [ astor ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "command line tool to automatically convert a project's Python code from old format style strings into Python 3.6+'s f-strings";
    homepage = "https://github.com/ikamensh/flynt";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
