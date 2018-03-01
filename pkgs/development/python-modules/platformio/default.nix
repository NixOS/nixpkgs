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
  version="3.5.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cc15mzh7p1iykip0jpxldz81yz946vrgvhwmfl8w3z5kgjjgx3n";
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
