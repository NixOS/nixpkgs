{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libvslvm-python";

  version = "20221025";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IUqSzlsTqZcqYBBXjY4MyRnOL6/Ks4FgBVN3fi70uA8=";
  };

  meta = with lib; {
    description = "Python bindings module for libvslvm";
    downloadPage = "https://github.com/libyal/libvslvm/releases";
    homepage = "https://github.com/libyal/libvslvm/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
