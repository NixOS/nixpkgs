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
  version = "0.3.8";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f1a5fzap4ji5l7x8bprrgcpy1071lpa9g5h8jz7iqzgqynkaygi";
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
