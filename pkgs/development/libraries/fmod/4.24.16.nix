{ stdenv, fetchurl }:

assert (stdenv.system == "x86_64-linux") || (stdenv.system == "i686-linux");
let
  bits = stdenv.lib.optionalString (stdenv.system == "x86_64-linux") "64";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc stdenv.cc.cc ] + ":${stdenv.cc.cc}/lib64";
  patchLib = x: "patchelf --set-rpath ${libPath} ${x}";

  src =
    (if (bits == "64") then
      fetchurl {
        url = "http://www.fmod.org/download/fmodex/api/Linux/fmodapi42416linux64.tar.gz";
        sha256 = "0hkwlzchzzgd7fanqznbv5bs53z2qy8iiv9l2y77l4sg1jwmlm6y";
      }
    else
      fetchurl {
        url = "http://www.fmod.org/download/fmodex/api/Linux/fmodapi42416linux.tar.gz";
        sha256 = "13diw3ax2slkr99mwyjyc62b8awc30k0z08cvkpk2p3i1j6f85m5";
      }
    );
in
stdenv.mkDerivation rec {
  inherit src;

  name    = "fmod-${version}";
  version = "4.24.16";

  dontStrip = true;
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/lib $out/include/fmodex

    cd api/inc && cp * $out/include/fmodex && cd ../lib
    cp libfmodex${bits}-${version}.so $out/lib/libfmodex.so
    cp libfmodex${bits}L-${version}.so $out/lib/libfmodexL.so

    ${patchLib "$out/lib/libfmodex.so"}
    ${patchLib "$out/lib/libfmodexL.so"}
  '';

  meta = {
    description = "Programming library and toolkit for the creation and playback of interactive audio";
    homepage    = "http://www.fmod.org/";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.lassulus ];
  };
}
