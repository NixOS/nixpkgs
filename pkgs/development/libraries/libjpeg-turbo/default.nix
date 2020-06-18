{ stdenv, fetchurl, fetchpatch, cmake, nasm, enableStatic ? false }:

stdenv.mkDerivation rec {

  pname = "libjpeg-turbo";
  version = "2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1ds16bnj17v6hzd43w8pzijz3imd9am4hw75ir0fxm240m8dwij2";
  };

  patches =
    [
      (fetchpatch {
        name = "cve-2020-13790.patch";
        url = "https://github.com/libjpeg-turbo/libjpeg-turbo/commit/3de15e0c344d.diff";
        sha256 = "0hm5i6qir5w3zxb0xvqdh4jyvbfg7xnd28arhyfsaclfz9wdb0pb";
      })
    ] ++
    stdenv.lib.optional (stdenv.hostPlatform.libc or null == "msvcrt")
      ./mingw-boolean.patch;

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ cmake nasm ];

  cmakeFlags = [
    "-DENABLE_STATIC=${if enableStatic then "1" else "0"}"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with stdenv.lib; {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = licenses.ijg; # and some parts under other BSD-style licenses
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.all;
  };
}
