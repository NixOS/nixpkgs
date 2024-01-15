{ lib, stdenv, fetchFromGitHub }:

let
  soVersion = "5";
in stdenv.mkDerivation rec {
  pname = "liblinear";
  version = "2.47";

  src = fetchFromGitHub {
    owner = "cjlin1";
    repo = "liblinear";
    rev = "v${builtins.replaceStrings ["."] [""] version}";
    sha256 = "sha256-so7uCc/52NdN0V2Ska8EUdw/wSegaudX5AF+c0xe5jk=";
  };

  makeFlags = [ "AR=${stdenv.cc.targetPrefix}ar" "RANLIB=${stdenv.cc.targetPrefix}ranlib" ];

  outputs = [ "bin" "dev" "out" ];

  buildFlags = [ "lib" "predict" "train" ];

  installPhase = ''
    ${if stdenv.isDarwin then ''
      install -D liblinear.so.${soVersion} $out/lib/liblinear.${soVersion}.dylib
      ln -s $out/lib/liblinear.${soVersion}.dylib $out/lib/liblinear.dylib
    '' else ''
      install -Dt $out/lib liblinear.so.${soVersion}
      ln -s $out/lib/liblinear.so.${soVersion} $out/lib/liblinear.so
    ''}
    install -D train $bin/bin/liblinear-train
    install -D predict $bin/bin/liblinear-predict
    install -Dm444 -t $dev/include linear.h
  '';

  meta = with lib; {
    description = "A library for large linear classification";
    homepage = "https://www.csie.ntu.edu.tw/~cjlin/liblinear/";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
