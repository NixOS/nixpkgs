{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libfsfat-python";
  name = pname;
  version = "20220925";

  meta = with lib; {
    description = "Python bindings module for libfsfat";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsfat/";
    downloadPage = "https://github.com/libyal/libfsfat/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dv1pGbNO73xogXrmon1swmjNu5ICEIKKx/D3uWdNNp4=";
  };
}
