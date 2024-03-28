{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libfsfat-python";

  version = "20220925";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dv1pGbNO73xogXrmon1swmjNu5ICEIKKx/D3uWdNNp4=";
  };

  meta = with lib; {
    description = "Python bindings module for libfsfat";
    downloadPage = "https://github.com/libyal/libfsfat/releases";
    homepage = "https://github.com/libyal/libfsfat/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };

}
