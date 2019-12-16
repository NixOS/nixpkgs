{ stdenv, fetchgit, fetchFromGitHub, cmake, pkgconfig, zlib, perl, libevent, boringssl }:
let
  boringssl' = boringssl.overrideAttrs (old: {
    version = "49de1fc2910524c888866c7e2b0db1ba8af2a530";
    src = fetchgit {
      url    = "https://boringssl.googlesource.com/boringssl";
      rev    = "49de1fc2910524c888866c7e2b0db1ba8af2a530";
      sha256 = "1yw6mxy2va4r41z00k0x0x5r4jkd1bhfcnkb0x9ibfda2qzlzw43";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "lsquic";
  version = "2.7.2";
  src = fetchFromGitHub {
    owner = "litespeedtech";
    repo = "lsquic";
    rev = "v${version}";
    sha256 = "1kkb32svbi493f9wlwc9wbg2ydq1kr0gjpalmp39ngf18lv20bad";
    fetchSubmodules = true;
  };
  postPatch = ''
    patchShebangs src/liblsquic/gen-verstrs.pl
  '';
  cmakeFlags = [
    "-DBORINGSSL_DIR=${boringssl'}"
    "-DZLIB_LIB=${zlib}/lib/libz.so"
    "-DEVENT_LIB=${libevent}/lib/libevent.so"
    "-DBORINGSSL_LIB_ssl=${boringssl'}/lib/libssl.a"
    "-DBORINGSSL_LIB_crypto=${boringssl'}/lib/libcrypto.a"
  ];
  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ boringssl' zlib libevent ];

  installPhase = ''
    mkdir -p $out/bin $out/include $out/lib

    mv {echo,http,md5}_{client,server} $out/bin
    mv ../include/*.h $out/include
    mv src/liblsquic/liblsquic.a $out/lib
  '';
}
