{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libfsext-python";
  name = pname;
  version = "20220829";

  meta = with lib; {
    description = "Python bindings module for libfsext";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsext/";
    downloadPage = "https://github.com/libyal/libfsext/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uldQDxEpImrl5oDw3Sy9Axj+oveqx6jhrS4HMeI/R5M=";
  };
}
