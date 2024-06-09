{ lib, stdenv , fetchurl }:

stdenv.mkDerivation rec {
  pname = "libsmi";
  version = "0.5.0";

  src = fetchurl {
    url = "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/${pname}-${version}.tar.gz";
    sha256 = "1lslaxr2qcj6hf4naq5n5mparfhmswsgq4wa7zm2icqvvgdcq6pj";
  };

  env.NIX_CFLAGS_COMPILE = "-std=gnu90";

  meta = with lib; {
    description = "Library to Access SMI MIB Information";
    homepage = "https://www.ibr.cs.tu-bs.de/projects/libsmi/index.html";
    license = licenses.free;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
