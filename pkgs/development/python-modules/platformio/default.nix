{ stdenv, buildPythonPackage, fetchPypi
, bottle, click_5, colorama
, lockfile, pyserial, requests
, semantic-version
, isPy3k, isPyPy
, git
}:
buildPythonPackage rec {
  disabled = isPy3k || isPyPy;

  pname = "platformio";
  version="3.5.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v74qb7jlfw7kbbb8wi4zcr3cyl8lhk1c1y28ny9ab7ip3jiqcdv";
  };

  propagatedBuildInputs =  [
    bottle click_5 colorama git lockfile
    pyserial requests semantic-version
  ];

  patches = [ ./fix-searchpath.patch ];

  meta = with stdenv.lib; {
    description = "An open source ecosystem for IoT development";
    homepage = http://platformio.org;
    maintainers = with maintainers; [ mog makefu ];
    license = licenses.asl20;
  };
}
