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
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf35b208fe05e65508f3b8bbb0f91d164b007632e27ebe5f54041174b681b696";
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
