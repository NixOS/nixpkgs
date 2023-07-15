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

let
  # Use usrsctp version specified at https://github.com/paullouisageneau/libdatachannel/tree/master/deps
  # Older or newer usrsctp might break libdatachannel, please keep it synced with upstream.
  customUsrsctp = usrsctp.overrideAttrs (finalAttrs: previousAttrs: {
    version = "unstable-2021-10-08";
    src = fetchFromGitHub {
      owner = "sctplab";
      repo = "usrsctp";
      rev = "7c31bd35c79ba67084ce029511193a19ceb97447";
      hash = "sha256-KeOR/0WDtG1rjUndwTUOhE21PoS+ETs1Vk7jQYy/vNs=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "libdatachannel";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ognjEDw68DpdQ/4JqcTejP5f9K0zLZGnpr99P/dvHK4=";
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
  ];

  cmakeFlags = [
    "-DUSE_NICE=ON"
    "-DUSE_SYSTEM_SRTP=ON"
    "-DNO_EXAMPLES=ON"
  ];

  postPatch = ''
    # TODO: Remove when updating to 0.19.x, and add
    # -DUSE_SYSTEM_USRSCTP=ON and -DUSE_SYSTEM_PLOG=ON to cmakeFlags instead
    mkdir -p deps/{usrsctp,plog}
    cp -r --no-preserve=mode ${srcOnly customUsrsctp}/. deps/usrsctp
    cp -r --no-preserve=mode ${srcOnly plog}/. deps/plog
  '';

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
