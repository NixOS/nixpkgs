{ stdenv, fetchurl, fetchpatch, cmake, nasm, enableStatic ? false, enableShared ? true }:

stdenv.mkDerivation rec {

  pname = "libjpeg-turbo";
  version = "2.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "01ill8bgjyk582wipx7sh7gj2nidylpbzvwhx0wkcm6mxx3qbp9k";
  };

  patches =
    [
      # Fixes race in tests that causes "jpegtran-shared-icc" to fail
      # https://github.com/libjpeg-turbo/libjpeg-turbo/pull/425
      (fetchpatch {
        url = "https://github.com/libjpeg-turbo/libjpeg-turbo/commit/a2291b252de1413a13db61b21863ae7aea0946f3.patch";
        sha256 = "0nc5vcch5h52gpi07h08zf8br58q8x81q2hv871hrn0dinb53vym";
      })

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
    "-DENABLE_SHARED=${if enableShared then "1" else "0"}"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with stdenv.lib; {
    homepage = "http://libjpeg-turbo.virtualgl.org/";
    description = "A faster (using SIMD) libjpeg implementation";
    license = licenses.ijg; # and some parts under other BSD-style licenses
    maintainers = with maintainers; [ vcunat colemickens ];
    platforms = platforms.all;
  };
}
