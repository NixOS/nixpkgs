{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libfsntfs-python";

  version = "20221023";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tjdkHy/ttKVlGucC9/0bk9ni2J5LdvD07e/mOLX25Zg=";
  };

  meta = with lib; {
    description = "Python bindings module for libfsntfs";
    downloadPage = "https://github.com/libyal/libfsntfs/releases";
    homepage = "https://github.com/libyal/libfsntfs/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
