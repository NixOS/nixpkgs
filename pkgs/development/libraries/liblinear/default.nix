{ stdenv, fetchFromGitHub, fixDarwinDylibNames }:

let
  soVersion = "4";
in stdenv.mkDerivation rec {
  pname = "liblinear";
  version = "2.41";

  src = fetchFromGitHub {
    owner = "cjlin1";
    repo = "liblinear";
    rev = "v${builtins.replaceStrings ["."] [""] version}";
    sha256 = "1mykrzka2wxnvvjh21hisabs5fsxqzdhkxw9m08h24c58vfiwsd8";
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

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

  meta = with stdenv.lib; {
    description = "A library for large linear classification";
    homepage = "https://www.csie.ntu.edu.tw/~cjlin/liblinear/";
    license = licenses.bsd3;
    maintainers = [ maintainers.danieldk ];
    platforms = platforms.unix;
  };
}
