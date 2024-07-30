{ lib, stdenv
, fetchurl
, Carbon
, libjpeg
, libpng
, withJpegSupport ? true # support jpeg output
, withPngSupport ? true # support png output
}:

stdenv.mkDerivation rec {
  pname = "tachyon";
  version = "0.99.5";
  src = fetchurl {
    url = "http://jedi.ks.uiuc.edu/~johns/tachyon/files/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-CSA8ECMRFJ9d9cw2dAn5bHJXQmZtGcJNtbqZTVqBpvU=";
  };
  buildInputs = lib.optionals stdenv.isDarwin [
    Carbon
  ] ++ lib.optionals withJpegSupport [
    libjpeg
  ] ++ lib.optionals withPngSupport [
    libpng
  ];
  preBuild = ''
    cd unix
  '' + lib.optionalString withJpegSupport ''
    export USEJPEG=" -DUSEJPEG"
    export JPEGLIB=" -ljpeg"
  '' + lib.optionalString withPngSupport ''
    export USEPNG=" -DUSEPNG"
    export PNGLIB=" -lpng -lz"
  '';
  arch = if stdenv.hostPlatform.system == "x86_64-linux"   then "linux-64-thr"  else
         if stdenv.hostPlatform.system == "i686-linux"     then "linux-thr"     else
         # 2021-03-29: multithread (-DTHR -D_REENTRANT) was disabled on linux-arm
         # because it caused Sage's 3D plotting tests to hang indefinitely.
         # see https://github.com/NixOS/nixpkgs/pull/117465
         if stdenv.hostPlatform.system == "aarch64-linux"  then "linux-arm"     else
         if stdenv.hostPlatform.system == "armv7l-linux"   then "linux-arm"     else
         if stdenv.hostPlatform.system == "aarch64-darwin" then "macosx"        else
         if stdenv.hostPlatform.system == "x86_64-darwin"  then "macosx-thr"    else
         if stdenv.hostPlatform.system == "i686-darwin"    then "macosx-64-thr" else
         if stdenv.hostPlatform.system == "i686-cygwin"    then "win32"         else
         if stdenv.hostPlatform.system == "x86_64-freebsd" then "bsd"           else
         if stdenv.hostPlatform.system == "x686-freebsd"   then "bsd"           else
         throw "Don't know what arch to select for tachyon build";
  makeFlags = [ arch ];

  patches = [
    # Remove absolute paths in Make-config (and unset variables so they can be set in preBuild)
    ./no-absolute-paths.patch
    # Include new targets (like arm)
    ./make-archs.patch
  ];
  postPatch = ''
    # Ensure looks for nix-provided Carbon, not system frameworks
    substituteInPlace unix/Make-arch \
      --replace '-F/System/Library/Frameworks' ""
  '';

  installPhase = ''
    cd ../compile/${arch}
    mkdir -p "$out"/{bin,lib,include,share/doc/tachyon,share/tachyon}
    cp tachyon "$out"/bin
    cp libtachyon.* "$out/lib"
    cd ../..
    cp src/*.h "$out/include/"
    cp Changes Copyright README "$out/share/doc/tachyon"
    cp -r scenes "$out/share/tachyon/scenes"
  '';
  meta = {
    description = "Parallel / Multiprocessor Ray Tracing System";
    mainProgram = "tachyon";
    license = lib.licenses.bsd3;
    maintainers = [lib.maintainers.raskin];
    platforms = with lib.platforms; linux ++ cygwin ++ darwin;
    homepage = "http://jedi.ks.uiuc.edu/~johns/tachyon/";
  };
}
