{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libvslvm-python";
  name = pname;
  version = "20221025";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IUqSzlsTqZcqYBBXjY4MyRnOL6/Ks4FgBVN3fi70uA8=";
  };

  meta = with lib; {
    description = "Python bindings module for libvslvm";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvslvm/";
    downloadPage = "https://github.com/libyal/libvslvm/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };
}
