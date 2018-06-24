{ stdenv, lib, fetchFromGitHub, fetchpatch, pkgconfig, automake, autoconf, zlib
, boost, openssl, libtool, python, libiconv, geoip }:

let
  version = "1.1.7";
  formattedVersion = lib.replaceChars ["."] ["_"] version;
in stdenv.mkDerivation {
  name = "libtorrent-rasterbar-${version}";

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "libtorrent-${formattedVersion}";
    sha256 = "073nb7yca5jg1i8z5h76qrmddl2hdy8fc1pnchkg574087an31r3";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/arvidn/libtorrent/commit/64d6b4900448097b0157abb328621dd211e2947d.patch";
      sha256 = "1bdv0icqzbg1il60sckcly4y22lkdbkkwdjadwdzxv7cdj586bzd";
    })
    (fetchpatch {
      url = "https://github.com/arvidn/libtorrent/commit/9cd0ae67e74a507c1b9ff9c057ee97dda38ccb81.patch";
      sha256 = "1cscqpc6fq9iwspww930dsxf0yb01bgrghzf5hdhl09a87r6q2zg";
    })
  ];

  enableParallelBuilding = true;
  nativeBuildInputs = [ automake autoconf libtool pkgconfig ];
  buildInputs = [ boost openssl zlib python libiconv geoip ];
  preConfigure = "./autotool.sh";

  configureFlags = [
    "--enable-python-binding"
    "--with-libgeoip=system"
    "--with-libiconv=yes"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-libiconv=yes"
  ];

  meta = with stdenv.lib; {
    homepage = "https://libtorrent.org/";
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.unix;
  };
}
