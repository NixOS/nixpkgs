{ lib, buildPythonPackage, fetchPypi, click, prompt-toolkit }:

buildPythonPackage rec {
  pname = "click-repl";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd12f68d745bf6151210790540b4cb064c7b13e571bc64b6957d98d120dacfd8";
  };

  propagatedBuildInputs = [ click prompt-toolkit ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-repl";
    description = "Subcommand REPL for click apps";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
