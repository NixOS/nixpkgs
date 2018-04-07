{ stdenv, buildPythonPackage, fetchPypi
, bottle, click, colorama
, lockfile, pyserial, requests
, semantic-version
, git
}:

buildPythonPackage rec {
  pname = "platformio";
  version="3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cc15mzh7p1iykip0jpxldz81yz946vrgvhwmfl8w3z5kgjjgx3n";
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
