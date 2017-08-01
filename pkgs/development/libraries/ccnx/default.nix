{ stdenv, fetchurl, openssl, expat, libpcap }:
let
  version = "0.8.2";
in
stdenv.mkDerivation {
  name = "ccnx-${version}";
  src = fetchurl {
    url = "https://github.com/ProjectCCNx/ccnx/archive/ccnx-${version}.tar.gz";
    sha256 = "1jyk7i8529821aassxbvzlxnvl5ly0na1qcn3v1jpxhdd0qqpg00";
  };
  buildInputs = [ openssl expat libpcap ];
  preConfigure = ''
    mkdir -p $out/include
    mkdir -p $out/lib
    mkdir -p $out/bin
    substituteInPlace csrc/configure --replace "/usr/local" $out --replace "/usr/bin/env sh" "/bin/sh"
  '';
  meta = with stdenv.lib; {
    homepage = http://www.ccnx.org/;
    description = "A Named Data Neworking (NDN) or Content Centric Networking (CCN) abstraction";
    longDescription = ''
      To address the Internet’s modern-day requirements with a better
      fitting model, PARC has created a new networking architecture
      called Content-Centric Networking (CCN), which operates by addressing
      and delivering Content Objects directly by Name instead of merely
      addressing network end-points. In addition, the CCN security model
      explicitly secures individual Content Objects rather than securing
      the connection or “pipe”. Named and secured content resides in
      distributed caches automatically populated on demand or selectively
      pre-populated. When requested by name, CCN delivers named content to
      the user from the nearest cache, thereby traversing fewer network hops,
      eliminating redundant requests, and consuming less resources overall.
    '';
    license = licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.sjmackenzie ];
  };
}
