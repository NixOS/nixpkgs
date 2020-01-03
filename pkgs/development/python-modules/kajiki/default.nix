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
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbec46b19285d42769d7c4f5a8a0195b72a62b54cd360a26a8875319d58efef6";
  };

  propagatedBuildInputs = [ Babel pytz nine ];
  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
  };

}
