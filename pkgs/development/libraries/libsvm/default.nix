{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libsvm-${version}";
  version = "3.22";

  src = fetchurl {
    url = "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-${version}.tar.gz";
    sha256 = "0zd7s19y5vb7agczl6456bn45cj1y64739sslaskw1qk7dywd0bd";
  };

  buildPhase = ''
  make
  make lib
  '';

  installPhase = let
    libSuff = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    mkdir -p $out/lib $out/bin $out/include;
    cp libsvm.so.2 $out/lib/libsvm.2${libSuff};
    ln -s $out/lib/libsvm.2${libSuff} $out/lib/libsvm${libSuff};
    cp svm-scale svm-train svm-predict $out/bin;
    cp svm.h $out/include;
  '';

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id libsvm.2.dylib $out/lib/libsvm.2.dylib;
  '';

  meta = with stdenv.lib; {
    description = "A library for support vector machines";
    homepage = https://www.csie.ntu.edu.tw/~cjlin/libsvm/;
    license = licenses.bsd3;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}
