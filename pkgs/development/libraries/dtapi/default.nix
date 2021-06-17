{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dtapi";
  version = "2020.08.0";

  src = fetchurl {
    url = "https://www.dektec.com/products/SDK/DTAPI/Downloads/LinuxSDK_v${version}.tar.gz";
    sha256 = "jjO5PWzlDd4gsv1+bpQcawTU1srkJwxXnbscIcwoB2s=";
  };

  postPatch = ''
    substituteInPlace DTAPI/Include/DTAPI.h --replace /usr/include/ ""
  '';

  installPhase = ''
    mkdir $out
    cp License $out
    cd DTAPI
    cp -r Include/ Lib/ $out
  '';

  meta = with stdenv.lib; {
    description = "Dektec DTAPI for PCI, PCI Express cards and USB devices";
    homepage = "https://www.dektec.com/downloads/SDK/";
    license = with licenses; [ unfreeRedistributable ];
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
