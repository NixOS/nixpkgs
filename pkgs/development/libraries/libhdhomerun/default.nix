{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libhdhomerun";
  version = "20200521";

  src = fetchurl {
    url = "https://download.silicondust.com/hdhomerun/libhdhomerun_${version}.tgz";
    sha256 = "0s0683bwyd10n3r2sanlyd07ii3fmi3vl9w9a2rwlpcclzq3h456";
  };

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace "gcc" "cc"
    substituteInPlace Makefile --replace "-arch i386" ""
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib,include/hdhomerun}
    install -Dm444 libhdhomerun${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
    install -Dm555 hdhomerun_config $out/bin
    cp *.h $out/include/hdhomerun
  '';

  meta = with stdenv.lib; {
    description = "Implements the libhdhomerun protocol for use with Silicondust HDHomeRun TV tuners";
    homepage = "https://www.silicondust.com/support/linux";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.titanous ];
  };
}
