{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "libsvm";
  version = "3.24";

  src = fetchurl {
    url = "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-${version}.tar.gz";
    sha256 = "15l69y23fxslrap415dvqb383x5fxvbffp9giszjfqjf38h1m26m";
  };

  buildPhase = ''
    make
    make lib
  '';

  installPhase = let
    libSuff = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    install -D libsvm.so.2 $out/lib/libsvm.2${libSuff}
    ln -s $out/lib/libsvm.2${libSuff} $out/lib/libsvm${libSuff}
    install -Dt $out/bin/ svm-scale svm-train svm-predict
    install -Dm644 -t $out/include svm.h
    mkdir $out/include/libsvm
    ln -s $out/include/svm.h $out/include/libsvm/svm.h
  '';

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id libsvm.2.dylib $out/lib/libsvm.2.dylib;
  '';

  meta = with stdenv.lib; {
    description = "A library for support vector machines";
    homepage = "https://www.csie.ntu.edu.tw/~cjlin/libsvm/";
    license = licenses.bsd3;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}
