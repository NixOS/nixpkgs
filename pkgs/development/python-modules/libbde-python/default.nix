{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libbde-python";
  name = pname;
  version = "20221031";

  meta = with lib; {
    description =
      "libbde is a library to access the BitLocker Drive Encryption (BDE) format";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libbde/";
    downloadPage = "https://github.com/libyal/libbde/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-62n9EgbdokMmmh3KQnFJdVZLVaRYc2ARyTwRJ10jOzA=";
  };
}
