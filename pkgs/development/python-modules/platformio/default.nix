{ stdenv, buildPythonPackage, fetchPypi
, arrow, bottle, click_5, colorama
, lockfile, pyserial, requests
, semantic-version
, isPy3k, isPyPy
}:
buildPythonPackage rec {
  disabled = isPy3k || isPyPy;

  pname = "platformio";
  version="3.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gy13cwp0i97lgjd8hh8kh9cswxh53x4cx2sq5b7d7vv8kd7bh6c";
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
