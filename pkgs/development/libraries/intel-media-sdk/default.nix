{ stdenv, fetchurl, autoPatchelfHook, cmake, pkgconfig, libdrm, libpciaccess
, libva , libX11, libXau, libXdmcp, libpthreadstubs
}:

stdenv.mkDerivation rec {
  pname = "intel-media-sdk";
  version = "19.4.0";

  src = fetchurl {
    url = "https://github.com/Intel-Media-SDK/MediaSDK/archive/intel-mediasdk-${version}.tar.gz";
    sha256 = "1l8wjb933wdl3vyq6r36a9pgf8n6pm9g9vcp3m393hixwzzl16i8";
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
    platforms = [ "x86_64-linux" ];
  };
}
