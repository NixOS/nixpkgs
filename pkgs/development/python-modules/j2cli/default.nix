{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, nose
, jinja2
, pyyaml
}:

buildPythonPackage rec {
  pname = "j2cli";
  version = "0.3.7";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7b0bdb02a3afb6d2eff40228b2216306332ace4341372310dafd15f938e1afa";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ jinja2 pyyaml ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kolypto/j2cli;
    description = "Jinja2 Command-Line Tool";
    license = licenses.bsd3;
    longDescription = ''
      J2Cli is a command-line tool for templating in shell-scripts,
      leveraging the Jinja2 library.
    '';
    maintainers = with maintainers; [ rushmorem ];
  };

}
