{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libvsgpt-python";
  name = pname;
  version = "20221029";

  meta = with lib; {
    description = "Python bindings module for libvsgpt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvsgpt/";
    downloadPage = "https://github.com/libyal/libvsgpt/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2GipPvRMA0viWQKIBCnp+PiLLpo4F0OeuNm0zMQ/SSU=";
  };
}
