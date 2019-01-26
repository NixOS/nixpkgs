{ stdenv, fetchFromGitHub, openssl, doxygen
, boost, sqlite, pkgconfig, python, pythonPackages, wafHook }:
let
  version = "0.6.3";
in
stdenv.mkDerivation {
  name = "ndn-cxx-${version}";
  src = fetchFromGitHub {
    owner = "named-data";
    repo = "ndn-cxx";
    rev = "a3bf4319ed483a4a6fe2c96b79ec4491d7217f00";
    sha256 = "076jhrjigisqz5n8dgxwd5fhimg69zhm834m7w9yvf9afgzrr50h";
  };
  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ openssl doxygen boost sqlite python pythonPackages.sphinx];
  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
  ];
  meta = with stdenv.lib; {
    homepage = http://named-data.net/;
    description = "A Named Data Neworking (NDN) or Content Centric Networking (CCN) abstraction";
    longDescription = ''
      ndn-cxx is a C++ library, implementing Named Data Networking (NDN)
      primitives that can be used to implement various NDN applications.
      NDN operates by addressing and delivering Content Objects directly
      by Name instead of merely addressing network end-points. In addition,
      the NDN security model explicitly secures individual Content Objects
      rather than securing the connection or “pipe”. Named and secured
      content resides in distributed caches automatically populated on
      demand or selectively pre-populated. When requested by name, NDN
      delivers named content to the user from the nearest cache, thereby
      traversing fewer network hops, eliminating redundant requests,
      and consuming less resources overall.
    '';
    license = licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.sjmackenzie ];
  };
}
