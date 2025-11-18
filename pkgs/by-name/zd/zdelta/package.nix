{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "zdelta";
  version = "2.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20160316212948/http://cis.poly.edu/zdelta/downloads/zdelta-2.1.tar.gz";
    sha256 = "sha256-WiQKWxJkINIwRBcdiuVLMDiupQ8gOsiXOEZvHDa5iFg=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -p zdc zdu $out/bin
  '';

  meta = with lib; {
    homepage = "https://web.archive.org/web/20160316212948/http://cis.poly.edu/zdelta/";
    platforms = platforms.all;
    license = licenses.zlib;
    # last successful hydra build on darwin was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
}
