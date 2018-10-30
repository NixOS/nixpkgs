{ stdenv
, buildPythonPackage
, fetchgit
, sphinx
, isPy3k
}:

buildPythonPackage rec {
  pname = "cliapp";
  version = "1.20150305";
  disabled = isPy3k;

  src = fetchgit {
      url = "http://git.liw.fi/cgi-bin/cgit/cgit.cgi/cliapp";
      rev = "569df8a5959cd8ef46f78c9497461240a5aa1123";
      sha256 = "882c5daf933e4cf089842995efc721e54361d98f64e0a075e7373b734cd899f3";
  };

  buildInputs = [ sphinx ];

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://liw.fi/cliapp/;
    description = "Python framework for Unix command line programs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ rickynils ];
  };

}
