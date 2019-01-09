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
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c46d231111fd661b733d417976e30a69f4e7fe6a8499bd59b4b3ea2a2504898c";
  };

  propagatedBuildInputs = [ pytz requests ];
  buildInputs = [ coverage mock nose unittest2 ];

  meta = with stdenv.lib; {
    description = "A Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = https://github.com/salimfadhley/jenkinsapi;
    maintainers = with maintainers; [ drets ];
    license = licenses.mit;
  };

}
