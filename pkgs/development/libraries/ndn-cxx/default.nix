{ lib
, stdenv
, fetchFromGitHub
, doxygen
, pkg-config
, python3
, python3Packages
, wafHook
, boost175
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
    sha256 = "sha256-oTSc/lh0fDdk7dQeDhYKX5+gFl2t2Xlu1KkNmw7DitE=";
  };

  nativeBuildInputs = [ doxygen pkg-config python3 python3Packages.sphinx wafHook ];

  buildInputs = [ boost175 openssl sqlite ];

  wafConfigureFlags = [
    "--with-openssl=${openssl.dev}"
    "--boost-includes=${boost175.dev}/include"
    "--boost-libs=${boost175.out}/lib"
    # "--with-tests" # disabled since upstream tests fail (Net/TestFaceUri/ParseDev Bug #3896)
  ];


  doCheck = false; # disabled since upstream tests fail (Net/TestFaceUri/ParseDev Bug #3896)
  checkPhase = ''
    runHook preCheck
    LD_PRELOAD=build/ndn-cxx.so build/unit-tests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://named-data.net/";
    description = "A Named Data Networking (NDN) or Content Centric Networking (CCN) abstraction";
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
