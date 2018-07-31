{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "liblinear-${version}";
  version = "2.20";

  src = fetchurl {
    url = "https://www.csie.ntu.edu.tw/~cjlin/liblinear/liblinear-${version}.tar.gz";
    sha256 = "13q48azqy9pd8jyhk0c2hzj5xav1snbdrj8pp38vwrv2wwhfz7rz";
  };

  buildPhase = ''
    make
    make lib
  '';

  installPhase = let
    libSuff = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    mkdir -p $out/lib $out/bin $out/include
    cp liblinear.so.3 $out/lib/liblinear.3${libSuff}
    ln -s $out/lib/liblinear.3${libSuff} $out/lib/liblinear${libSuff}
    cp train $out/bin/liblinear-train
    cp predict $out/bin/liblinear-predict
    cp linear.h $out/include
  '';

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id liblinear.3.dylib $out/lib/liblinear.3.dylib
  '';

  meta = with stdenv.lib; {
    description = "A library for large linear classification";
    homepage = https://www.csie.ntu.edu.tw/~cjlin/liblinear/;
    license = licenses.bsd3;
    maintainers = [ maintainers.danieldk ];
    platforms = platforms.unix;
  };
}
