{ stdenv, buildPythonPackage, fetchPypi
, pep8, coverage, logilab_common, requests }:

buildPythonPackage rec {
  pname = "bugzilla";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ikx21nm7cch4lz9agv5h1hx6zvg2alkpfdrl01khqgilhsicdhi";
  };

  patches = [ ./checkPhase-fix-cookie-compare.patch ];

  buildInputs = [ pep8 coverage logilab_common ];
  propagatedBuildInputs = [ requests ];

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  meta = with stdenv.lib; {
    homepage = https://fedorahosted.org/python-bugzilla/;
    description = "Bugzilla XMLRPC access module";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron ];
  };
}
