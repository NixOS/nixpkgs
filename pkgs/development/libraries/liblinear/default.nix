{ lib, stdenv, fetchFromGitHub, fixDarwinDylibNames }:

let
  soVersion = "4";
in stdenv.mkDerivation rec {
  pname = "liblinear";
  version = "2.43";

  src = fetchFromGitHub {
    owner = "cjlin1";
    repo = "liblinear";
    rev = "v${builtins.replaceStrings ["."] [""] version}";
    sha256 = "sha256-qcSMuWHJgsapWs1xgxv3fKSXcx18q8cwyIn3E4RCGKA=";
  };

  postPatch = ''
    substituteInPlace blas/Makefile \
      --replace "ar rcv" "${stdenv.cc.targetPrefix}ar rcv" \
      --replace "ranlib" "${stdenv.cc.targetPrefix}ranlib"
  '';

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

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
