{ stdenv, fetchurl }:

assert (stdenv.system == "x86_64-linux") || (stdenv.system == "i686-linux");
let
  bits = stdenv.lib.optionalString (stdenv.system == "x86_64-linux") "64";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc stdenv.cc.cc ] + ":${stdenv.cc.cc.lib}/lib64";
  patchLib = x: "patchelf --set-rpath ${libPath} ${x}";
in
stdenv.mkDerivation rec {
  name    = "fmod-${version}";
  version = "4.44.41";

  src = fetchurl {
    url = "http://www.fmod.org/download/fmodex/api/Linux/fmodapi44441linux.tar.gz";
    sha256 = "0qjvbhx9g6ijv542n6w3ryv20f74p1qx6bbllda9hl14683z8r8p";
  };

  dontStrip = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib $out/include/fmodex

    cd api/inc && cp * $out/include/fmodex && cd ../lib
    cp libfmodex${bits}-${version}.so  $out/lib/libfmodex.so
    cp libfmodexL${bits}-${version}.so $out/lib/libfmodexL.so

    ${patchLib "$out/lib/libfmodex.so"}
    ${patchLib "$out/lib/libfmodexL.so"}
  '';

  meta = {
    description = "Programming library and toolkit for the creation and playback of interactive audio";
    homepage    = "http://www.fmod.org/";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
