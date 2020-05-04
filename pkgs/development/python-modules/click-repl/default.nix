{ stdenv, buildPythonPackage, fetchPypi, click, prompt_toolkit }:

buildPythonPackage rec {
  pname = "click-repl";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mcmz95595nrp4r58spy1ac993db26hk4q97isghbmn4md99vwmr";
  };

  propagatedBuildInputs = [ click prompt_toolkit ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/click-contrib/click-repl";
    description = "Subcommand REPL for click apps";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
