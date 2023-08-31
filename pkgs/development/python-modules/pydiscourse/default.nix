{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pydiscourse";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydiscourse";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-peDkXRcD/ieWYWXqv8hPxTSNRXBHcb/3sj/JJSF2RYg=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "pydiscourse"
  ];

  meta = with lib; {
    description = "A Python library for working with Discourse";
    homepage = "https://github.com/pydiscourse/pydiscourse";
    changelog = "https://github.com/pydiscourse/pydiscourse/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Dettorer ];
  };
}
