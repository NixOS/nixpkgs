with import <nixpkgs> {};
# { lib
# , buildPythonPackage
# , fetchFromGithub
# , pythonOlder
# , darkdetect
# , typing-extensions
# , packaging
# }:

python3.pkgs.buildPythonPackage rec {
  pname = "customtkinter";
  version = "5.2.2";
  format = "build";

  disabled = python3.pkgs.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TomSchimansky";
    repo = "CustomTkinter";
    rev = "v" + version;
    hash = "sha256-1g2wdXbUv5xNnpflFLXvU39s16kmwvuegKWd91E3qm4=";
  };

  propagatedBuildInputs = with python311Packages; [
    darkdetect
    typing-extensions
    packaging
  ];

  pythonImportsCheck = [
    "customtkinter"
  ];

  meta = with lib; {
    description = "A modern and customizable python UI-library based on Tkinter: https://customtkinter.tomschimansky.com";
    homepage = "https://customtkinter.tomschimansky.com/";
    changelog = "https://github.com/TomSchimansky/CustomTkinter/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ nktrjsk ];
  };
}