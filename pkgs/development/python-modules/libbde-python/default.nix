{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libbde-python";

  version = "20221031";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-62n9EgbdokMmmh3KQnFJdVZLVaRYc2ARyTwRJ10jOzA=";
  };

  meta = with lib; {
    description = "libbde is a library to access the BitLocker Drive Encryption (BDE) format";
    downloadPage = "https://github.com/libyal/libbde/releases";
    homepage = "https://github.com/libyal/libbde/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
