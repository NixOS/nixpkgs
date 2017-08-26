{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "tachyon-${version}";
  version = "0.98.9";
  src = fetchurl {
    url = "http://jedi.ks.uiuc.edu/~johns/tachyon/files/${version}/${name}.tar.gz";
    sha256 = "1ms0xr4ibrzz291ibm265lyjrdjrmhfrx0a70hwykhsdxn6jk8y6";
  };
  buildInputs = [];
  preBuild = "cd unix";
  arch = if stdenv.system == "x86_64-linux" then "linux-64-thr" else
         if stdenv.system == "i686-linux"   then "linux-thr"    else
         throw "Don't know what arch to select for tachyon build";
  makeFlags = "${arch}";
  installPhase = ''
    cd ../compile/${arch}
    mkdir -p "$out"/{bin,lib,include,share/doc/tachyon,share/tachyon}
    cp tachyon "$out"/bin
    cp libtachyon.* "$out/lib"
    cd ../..
    cp Changes Copyright README "$out/share/doc/tachyon"
    cp -r scenes "$out/share/tachyon/scenes"
  '';
  meta = {
    inherit version;
    description = ''A Parallel / Multiprocessor Ray Tracing System'';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://jedi.ks.uiuc.edu/~johns/tachyon/;
  };
}
