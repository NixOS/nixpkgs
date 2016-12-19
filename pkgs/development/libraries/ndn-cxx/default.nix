{ stdenv, fetchgit, openssl, doxygen, boost, sqlite, cryptopp, pkgconfig, python, pythonPackages }:
let
  version = "4c32e7";
in
stdenv.mkDerivation {
  name = "ndn-cxx-0.1-${version}";
  src = fetchgit {
    url = "https://github.com/named-data/ndn-cxx.git";
    rev = "4c32e748863d5165cc0e3d6b54a8383f4836cdf1";
    sha256 = "18szs3j3ig8wlcqngran0daxaj7j2qsmch0212ids6fymj1hgax4";
  };
  buildInputs = [ openssl doxygen boost sqlite cryptopp pkgconfig python pythonPackages.sphinx];
  preConfigure = ''
    patchShebangs waf
    ./waf configure \
      --with-cryptopp=${cryptopp} \
      --boost-includes=${boost.dev}/include \
      --boost-libs=${boost.out}/lib \
      --with-examples \
      --prefix=$out
  '';
  buildPhase = ''
    ./waf
  '';
  installPhase = ''
    ./waf install
  '';
  meta = with stdenv.lib; {
    homepage = "http://named-data.net/";
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
