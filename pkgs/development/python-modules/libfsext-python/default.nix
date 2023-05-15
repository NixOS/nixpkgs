{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libfsext-python";

  version = "20220829";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uldQDxEpImrl5oDw3Sy9Axj+oveqx6jhrS4HMeI/R5M=";
  };

  meta = with lib; {
    description = "Python bindings module for libfsext";
    downloadPage = "https://github.com/libyal/libfsext/releases";
    homepage = "https://github.com/libyal/libfsext/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
