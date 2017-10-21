{ stdenv, fetchurl, pkgconfig, libxml2, swig2, python2Packages, glib }:

let
  inherit (python2Packages) python cython;
in stdenv.mkDerivation rec {
  name = "libplist-${version}";
  version = "2.0.0";

  nativeBuildInputs = [ pkgconfig swig2 python cython ];

  propagatedBuildInputs = [ glib ];

  passthru.swig = swig2;

  outputs = ["out" "dev" "bin" "py"];

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  src = fetchurl {
    url = "http://www.libimobiledevice.org/downloads/${name}.tar.bz2";
    sha256 = "00pnh9zf3iwdji2faccns7vagbmbrwbj9a8zp9s53a6rqaa9czis";
  };

  meta = {
    homepage = https://github.com/JonathanBeck/libplist;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
