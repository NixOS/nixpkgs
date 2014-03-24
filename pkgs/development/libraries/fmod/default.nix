{ stdenv, fetchurl }:

assert (stdenv.system == "x86_64-linux") || (stdenv.system == "i686-linux");
let
  bits = stdenv.lib.optionalString (stdenv.system == "x86_64-linux") "64";
in
stdenv.mkDerivation rec {
  name    = "fmod-${version}";
  version = "4.44.32";

  src = fetchurl {
    url = "http://www.fmod.org/download/fmodex/api/Linux/fmodapi44432linux.tar.gz";
    sha256 = "071m2snzz5vc5ca7dvsf6w31nrgk5k9xb6mp7yzqdj4bkjad2hyd";
  };

  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/lib $out/include/fmodex

    cd api/inc && cp * $out/include/fmodex && cd ../lib
    cp libfmodex${bits}-${version}.so  $out/lib/libfmodex.so
    cp libfmodexL${bits}-${version}.so $out/lib/libfmodexL.so
  '';

  meta = {
    description = "Programming library and toolkit for the creation and playback of interactive audio";
    homepage    = "http://www.fmod.org/";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
