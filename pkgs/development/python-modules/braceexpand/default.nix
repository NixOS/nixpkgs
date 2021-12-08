{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "braceexpand";
  version = "0.1.7";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
     owner = "trendels";
     repo = "braceexpand";
     rev = "v0.1.7";
     sha256 = "07nmh2556d46fnnhh1643sf4yg0ljifjkgjp6vkjfp9zbz43bd0s";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braceexpand" ];

  meta = with lib; {
    description = "Bash-style brace expansion for Python";
    homepage = "https://github.com/trendels/braceexpand";
    changelog = "https://github.com/trendels/braceexpand/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
