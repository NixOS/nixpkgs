{ stdenv, buildPythonPackage, fetchPypi
, unittest2, lxml, robotframework
}:

buildPythonPackage rec {
  pname = "robotsuite";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8764e01990ac6774e0c983579bcb9cb79f44373a61ad47fbae9a1dc7eedbdd61";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace robotframework-python3 robotframework
  '';

  meta = with stdenv.lib; {
    description = "Python unittest test suite for Robot Framework";
    homepage = "https://github.com/collective/robotsuite/";
    license = licenses.gpl3;
  };
}
