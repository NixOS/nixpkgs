{ stdenv , fetchurl }:

stdenv.mkDerivation rec {
  name = "libsmi-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/${name}.tar.gz";
    sha256 = "1lslaxr2qcj6hf4naq5n5mparfhmswsgq4wa7zm2icqvvgdcq6pj";
  };

  meta = with stdenv.lib; {
    description = "A Library to Access SMI MIB Information";
    homepage = "https://www.ibr.cs.tu-bs.de/projects/libsmi/index.html";
    license = licenses.free;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
