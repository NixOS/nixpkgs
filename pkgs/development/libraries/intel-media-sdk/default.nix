{ stdenv, fetchurl, autoPatchelfHook, cmake, pkgconfig, libdrm, libpciaccess
, libva , libX11, libXau, libXdmcp, libpthreadstubs
}:

stdenv.mkDerivation rec {
  pname = "intel-media-sdk";
  version = "19.3.0";

  src = fetchurl {
    url = "https://github.com/Intel-Media-SDK/MediaSDK/archive/intel-mediasdk-${version}.tar.gz";
    sha256 = "0pgg16a4gsh8yjyz64r28bmkg9xxcy8m0dkvrdz03svkll9v7v3n";
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
