{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libfsxfs-python";

  version = "20220829";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mNvSLO/B69zQILEcVTTbL3YXJJJOm0o74SG2HZ0+U0M=";
  };

  meta = with lib; {
    description = "Python bindings module for libfsxfs";
    downloadPage = "https://github.com/libyal/libfsxfs/releases";
    homepage = "https://github.com/libyal/libfsxfs/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
