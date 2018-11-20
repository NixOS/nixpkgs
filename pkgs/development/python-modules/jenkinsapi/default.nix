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
  version = "0.2.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fcc78b8dfc87237942aad2a8be54dbc08bc4afceaa7f6897f3d894e7d4bfd22";
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
