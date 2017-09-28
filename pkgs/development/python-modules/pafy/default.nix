{ lib, buildPythonPackage, youtube-dl, fetchPypi }:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pafy";
  version = "0.5.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a7dxi95m1043rxx1r5x3ngb66nwlq6aqcasyqqjzmmmjps4zrim";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [ youtube-dl ];

  meta = with lib; {
    description = "A library to download YouTube content and retrieve metadata";
    homepage = http://np1.github.io/pafy/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ odi ];
  };
}

