{ stdenv, fetchurl, autoPatchelfHook, cmake, pkgconfig, libdrm, libpciaccess
, libva , libX11, libXau, libXdmcp, libpthreadstubs
}:

stdenv.mkDerivation rec {
  pname = "intel-media-sdk";
  version = "19.2.1";

  src = fetchurl {
    url = "https://github.com/Intel-Media-SDK/MediaSDK/archive/intel-mediasdk-${version}.tar.gz";
    sha256 = "0w3r6lr2q3kch0vz9sxld1nz6iff129xr8wzg0p2j7mng41imh83";
  };

  # patchelf is needed for binaries in $out/share/samples
  nativeBuildInputs = [ autoPatchelfHook cmake pkgconfig ];
  buildInputs = [
    libdrm libva libpciaccess libX11 libXau libXdmcp libpthreadstubs
  ];

  enableParallelBuild = true;

  meta = with stdenv.lib; {
    description = "Intel Media SDK.";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    platforms = with platforms; linux;
  };
}
