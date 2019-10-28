{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, requests
, coverage
, mock
, nose
, unittest2
}:

buildPythonPackage rec {
  pname = "jenkinsapi";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc2fcdf95d954d9bbbdb1303a2c3c32997935655c99aff300f1759dba3cebc6d";
  };

  propagatedBuildInputs = [ pytz requests ];
  buildInputs = [ coverage mock nose unittest2 ];

  meta = with stdenv.lib; {
    description = "A Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = https://github.com/salimfadhley/jenkinsapi;
    maintainers = with maintainers; [ drets ];
    license = licenses.mit;
    broken = true;
  };

}
