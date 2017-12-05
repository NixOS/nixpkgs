{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libsvm-${version}";
  version = "3.20";

  src = fetchurl {
    url = "http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-${version}.tar.gz";
    sha256 = "1gj5v5zp1qnsnv0iwxq0ikhf8262d3s5dq6syr6yqkglps0284hg";
  };

  buildPhase = ''
  make
  make lib
  '';

  installPhase = let
    libSuff = if stdenv.isDarwin then "dylib" else "so";
  in ''
    mkdir -p $out/lib $out/bin $out/include;
    cp libsvm.so.2 $out/lib/libsvm.2.${libSuff};
    ln -s $out/lib/libsvm.2.${libSuff} $out/lib/libsvm.${libSuff};
    cp svm-scale svm-train svm-predict $out/bin;
    cp svm.h $out/include;
  '';

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id libsvm.2.dylib $out/lib/libsvm.2.dylib;
  '';

  meta = with stdenv.lib; {
    description = "A library for support vector machines";
    homepage = http://www.csie.ntu.edu.tw/~cjlin/libsvm/;
    license = licenses.bsd3;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}
