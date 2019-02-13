{ stdenv
, buildPythonPackage
, fetchPypi
, Babel
, pytz
, nine
, nose
}:

buildPythonPackage rec {
  pname = "Kajiki";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e7aaf838f298958cf171f220e1d0dc4220338c76c97746a46d0cc389f90b10a";
  };

  propagatedBuildInputs = [ Babel pytz nine ];
  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
  };

}
