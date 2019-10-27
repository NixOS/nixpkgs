{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, jinja2
, pyyaml
}:

buildPythonPackage rec {
  pname = "j2cli";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f6f643b3fa5c0f72fbe9f07e246f8e138052b9f689e14c7c64d582c59709ae4";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ jinja2 pyyaml ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/kolypto/j2cli";
    description = "Jinja2 Command-Line Tool";
    license = licenses.bsd2;
    longDescription = ''
      J2Cli is a command-line tool for templating in shell-scripts,
      leveraging the Jinja2 library.
    '';
    maintainers = with maintainers; [ rushmorem ];
  };

}
