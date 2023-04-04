{ buildPythonPackage, fetchPypi, lib, zlib }:
buildPythonPackage rec {
  pname = "libfshfs-python";
  name = pname;
  version = "20220831";

  meta = with lib; {
    description = "Python bindings module for libfshfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfshfs/";
    downloadPage = "https://github.com/libyal/libfshfs/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vKZapQz/xK/YrvZ4+rMCdId8j/6EjiBnM4AMwD1E108=";
  };
}
