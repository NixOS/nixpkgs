{ stdenv, buildPythonPackage, fetchPypi
, bottle, click, colorama
, lockfile, pyserial, requests
, semantic-version
, git
}:

buildPythonPackage rec {
  pname = "platformio";
  version = "3.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb311ce5b8f12c95bc45c2071626a4887a3632fb2472b4d69a873b2acfc2e4ec";
  };

  propagatedBuildInputs =  [
    bottle click colorama git lockfile
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
