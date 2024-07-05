{ stdenv
, autoconf
, automake
, fetchFromGitHub
, fetchpatch
, lib
, libimobiledevice
, libusb1
, libplist
, libtool
, openssl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "ios-webkit-debug-proxy";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cZ/p/aWET/BXKDrD+qgR+rfTISd+4jPNQFuV8klSLUo=";
  };

  patches = [
    # OpenSSL 3.0 compatibility
    (fetchpatch {
      url = "https://github.com/google/ios-webkit-debug-proxy/commit/5ba30a2a67f39d25025cadf37c0eafb2e2d2d0a8.patch";
      hash = "sha256-2b9BjG9wkqO+ZfoBYYJvD2Db5Kr0F/MxKMTRsI0ea3s=";
    })
    (fetchpatch {
      name = "libplist-2.3.0-compatibility.patch";
      url = "https://github.com/google/ios-webkit-debug-proxy/commit/94e4625ea648ece730d33d13224881ab06ad0fce.patch";
      hash = "sha256-2deFAKIcNPDd1loOSe8pWZWs9idIE5Q2+pLkoVQrTLg=";
    })
    # Examples compilation breaks with --disable-static, see https://github.com/google/ios-webkit-debug-proxy/issues/399
    ./0001-Don-t-compile-examples.patch
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];
  buildInputs = [ libimobiledevice libusb1 libplist openssl ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "DevTools proxy (Chrome Remote Debugging Protocol) for iOS devices (Safari Remote Web Inspector)";
    mainProgram = "ios_webkit_debug_proxy";
    longDescription = ''
      The ios_webkit_debug_proxy (aka iwdp) proxies requests from usbmuxd
      daemon over a websocket connection, allowing developers to send commands
      to MobileSafari and UIWebViews on real and simulated iOS devices.
    '';
    homepage = "https://github.com/google/ios-webkit-debug-proxy";
    license = licenses.bsd3;
    maintainers = [ maintainers.abustany ];
  };
}
