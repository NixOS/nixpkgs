{ lib
, stdenv
, fetchFromGitHub
, doxygen
, pkg-config
, python3
, python3Packages
, wafHook
, boost179
, openssl
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "ndn-cxx";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "ndn-cxx";
    rev = "${pname}-${version}";
    sha256 = "sha256-nnnxlkYVTSRB6ZcuIUDFol999+amGtqegHXK+06ITK8=";
  };

  nativeBuildInputs = [ doxygen pkg-config python3 python3Packages.sphinx wafHook ];

  buildInputs = [ boost179 openssl sqlite ];

  wafConfigureFlags = [
    "--with-openssl=${openssl.dev}"
    "--boost-includes=${boost179.dev}/include"
    "--boost-libs=${boost179.out}/lib"
    "--with-tests"
  ];

  doCheck = false; # some tests fail in upstream, some fail because of the sandbox environment
  checkPhase = ''
    runHook preCheck
    LD_PRELOAD=build/libndn-cxx.so build/unit-tests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://named-data.net/";
    description = "Named Data Networking (NDN) or Content Centric Networking (CCN) abstraction";
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
    maintainers = with maintainers; [ sjmackenzie bertof ];
  };
}
