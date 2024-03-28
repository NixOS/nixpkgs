{ buildPythonPackage, fetchPypi, lib, zlib }:

buildPythonPackage rec {
  pname = "libfshfs-python";

  version = "20220831";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vKZapQz/xK/YrvZ4+rMCdId8j/6EjiBnM4AMwD1E108=";
  };

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Python bindings module for libfshfs";
    downloadPage = "https://github.com/libyal/libfshfs/releases";
    homepage = "https://github.com/libyal/libfshfs/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
