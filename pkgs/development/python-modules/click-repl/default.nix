{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, prompt-toolkit
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-repl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-repl";
    rev = version;
    hash = "sha256-kaTUKaIomJL0u3NX40bL0I54vkR+Utcdw1QKSbnVy5s=";
  };

  propagatedBuildInputs = [
    click
    prompt-toolkit
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-repl";
    description = "Subcommand REPL for click apps";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
