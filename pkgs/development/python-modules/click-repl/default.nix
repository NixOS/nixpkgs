{ lib, buildPythonPackage, fetchFromGitHub, click, prompt-toolkit }:

buildPythonPackage rec {
  pname = "click-repl";
  version = "0.2.0";

  src = fetchFromGitHub {
     owner = "click-contrib";
     repo = "click-repl";
     rev = "0.2.0";
     sha256 = "16ybsnwlj2jlqcfxflky8jz7i3nhrd3f6mvkpgs95618l8lx994i";
  };

  propagatedBuildInputs = [ click prompt-toolkit ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-repl";
    description = "Subcommand REPL for click apps";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
