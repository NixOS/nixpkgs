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
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a212a244b0a6022a61657746c8120ac9b6db83432371b345154075eb8faceb61";
  };

  propagatedBuildInputs = [ pytz requests ];
  buildInputs = [ coverage mock nose unittest2 ];

  meta = with stdenv.lib; {
    description = "A Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = "https://github.com/salimfadhley/jenkinsapi";
    maintainers = with maintainers; [ drets ];
    license = licenses.mit;
    broken = true;
  };

}
