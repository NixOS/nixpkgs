{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libvsgpt-python";

  version = "20221029";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2GipPvRMA0viWQKIBCnp+PiLLpo4F0OeuNm0zMQ/SSU=";
  };

  meta = with lib; {
    description = "Python bindings module for libvsgpt";
    downloadPage = "https://github.com/libyal/libvsgpt/releases";
    homepage = "https://github.com/libyal/libvsgpt/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };

}
