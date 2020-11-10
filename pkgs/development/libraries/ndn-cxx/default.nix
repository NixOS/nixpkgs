{ stdenv
, fetchFromGitHub
, doxygen
, pkg-config
, python3
, python3Packages
, wafHook
, boost
, openssl
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "ndn-cxx";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "ndn-cxx";
    rev = "${pname}-${version}";
    sha256 = "1lcaqc79n3d9sip7knddblba17sz18b0w7nlxmj3fz3lb3z9qd51";
  };

  nativeBuildInputs = [ doxygen pkg-config python3 python3Packages.sphinx wafHook ];

  buildInputs = [ boost openssl sqlite ];

  wafConfigureFlags = [
    "--with-openssl=${openssl.dev}"
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
  ];

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
    platforms = platforms.unix;
    maintainers = with maintainers; [ sjmackenzie ];
  };
}
