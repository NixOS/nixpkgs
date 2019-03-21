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
  version = "0.3.5.post1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0439a79308aae320bfd01d82b56893b02fe461195d8b69b438ba9b333075642";
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
