{ lib
, stdenv
, fetchurl
, fixDarwinDylibNames
, llvmPackages
, withOpenMP ? true
}:

stdenv.mkDerivation rec {
  pname = "libsvm";
  version = "3.33";

  src = fetchurl {
    url = "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-${version}.tar.gz";
    sha256 = "sha256-1doSzMPQ7thFP732+sfZ8AUvPopfB6IXTk7wqdg9zfg=";
  };

  patches = lib.optionals withOpenMP [ ./openmp.patch ];

  buildInputs = lib.optionals (stdenv.cc.isClang && withOpenMP) [ llvmPackages.openmp ];

  buildFlags = [ "lib" "all" ];

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  installPhase =
    let
      libSuff = stdenv.hostPlatform.extensions.sharedLibrary;
      soVersion = "3";
      libName = if stdenv.hostPlatform.isDarwin then "libsvm.${soVersion}${libSuff}" else "libsvm${libSuff}.${soVersion}";
    in
    ''
      runHook preInstall

      install -D libsvm.so.${soVersion} $out/lib/${libName}
      ln -s $out/lib/${libName} $out/lib/libsvm${libSuff}

      install -Dt $bin/bin/ svm-scale svm-train svm-predict

      install -Dm644 -t $dev/include svm.h
      mkdir $dev/include/libsvm
      ln -s $dev/include/svm.h $dev/include/libsvm/svm.h

      runHook postInstall
    '';

  meta = with lib; {
    description = "Library for support vector machines";
    homepage = "https://www.csie.ntu.edu.tw/~cjlin/libsvm/";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
