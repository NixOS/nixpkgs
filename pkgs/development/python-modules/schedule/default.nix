{ stdenv
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "schedule";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h0waw4jd5ql68y5kxb9irwapkbkwfs1w0asvbl24fq5f8czdijm";
  };

  buildInputs = [ mock ];

  meta = with stdenv.lib; {
    description = "Python job scheduling for humans";
    homepage = https://github.com/dbader/schedule;
    license = licenses.mit;
  };

}
