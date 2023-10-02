{ stdenv
, lib
, fetchFromGitHub
, srcOnly
, cmake
, ninja
, pkg-config
, libnice
, openssl
, plog
, srtp
, usrsctp
}:

stdenv.mkDerivation rec {
  pname = "libdatachannel";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jsJTECSR3ptiByfYQ00laeKMKJCv5IDkZmilY3jpRrU=";
  };

  outputs = [ "out" "dev" ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    libnice
    openssl
    srtp
    usrsctp
    plog
  ];

  cmakeFlags = [
    "-DUSE_NICE=ON"
    "-DPREFER_SYSTEM_LIB=ON"
    "-DNO_EXAMPLES=ON"
  ];

  postFixup = ''
    # Fix shared library path that will be incorrect on move to "dev" output
    substituteInPlace "$dev/lib/cmake/LibDataChannel/LibDataChannelTargets-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib" "$out/lib"
  '';

  meta = with lib; {
    description = "C/C++ WebRTC network library featuring Data Channels, Media Transport, and WebSockets";
    homepage = "https://libdatachannel.org/";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ erdnaxe ];
    platforms = platforms.linux;
  };
}
