{ stdenv, fetchurl, openssl, zlib, windows }:

stdenv.mkDerivation rec {
  pname = "libssh2";
  version = "1.9.0";

  src = fetchurl {
    url = "${meta.homepage}/download/${pname}-${version}.tar.gz";
    sha256 = "1zfsz9nldakfz61d2j70pk29zlmj7w2vv46s9l3x2prhcgaqpyym";
  };

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs = [ openssl zlib ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64;

  patches = [
    # not able to use fetchpatch here: infinite recursion
    (fetchurl {
      name = "CVE-2019-17498.patch";
      url = "https://github.com/libssh2/libssh2/pull/402.patch";
      sha256 = "1n9s2mcz5dkw0xpm3c5x4hzj8bar4i6z0pr1rmqjplhfg888vdvc";
    })
  ];

  meta = with stdenv.lib; {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = https://www.libssh2.org;
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
