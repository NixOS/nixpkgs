{ lib, buildPythonPackage, youtube-dl, fetchPypi }:
buildPythonPackage rec {
  pname = "pafy";
  version = "0.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "364f1d1312c89582d97dc7225cf6858cde27cb11dfd64a9c2bab1a2f32133b1e";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [ youtube-dl ];

  meta = with lib; {
    description = "A library to download YouTube content and retrieve metadata";
    homepage = https://github.com/mps-youtube/pafy;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ odi ];
  };
}

