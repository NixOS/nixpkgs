{ stdenv, buildPythonPackage, fetchPypi
, arrow, bottle, click_5, colorama
, lockfile, pyserial, requests
, semantic-version
, isPy3k, isPyPy
}:
buildPythonPackage rec {
  disabled = isPy3k || isPyPy;

  pname = "platformio";
  version="3.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b4lba672l851sv1xwc320xbh46x7hx4ms6whc0k37hxkxj0nwm2";
  };

  propagatedBuildInputs =  [
    arrow bottle click_5 colorama
    lockfile pyserial requests semantic-version
  ];

  patches = [ ./fix-searchpath.patch ];

  meta = with stdenv.lib; {
    description = "An open source ecosystem for IoT development";
    homepage = http://platformio.org;
    maintainers = with maintainers; [ mog makefu ];
    license = licenses.asl20;
  };
}
