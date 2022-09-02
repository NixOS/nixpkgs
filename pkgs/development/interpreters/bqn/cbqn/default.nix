{ lib
, stdenv
, fetchFromGitHub
, genBytecode ? false
, bqn-path ? null
, mbqn-source ? null
}:

let
  cbqn-bytecode-files = fetchFromGitHub {
    name = "cbqn-bytecode-files";
    owner = "dzaima";
    repo = "CBQN";
    rev = "c39653c898531a2cdbf4cc5c764df6e37b1894a4";
    hash = "sha256-JCEmkwh5Rv5+NQoxvefSrYnayU892/Wam+gjMgcQmO0=";
  };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));

stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "0.pre+date=2022-05-06";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "3496a939b670f8c9ca2a04927378d6b7e9abd68e";
    hash = "sha256-P+PoY4XF9oEw7VIpmybvPp+jxWHEo2zt1Lamayf1mHg=";
  };

  dontConfigure = true;

  postPatch = ''
    sed -i '/SHELL =.*/ d' makefile
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preBuild = ''
    # Purity: avoids git downloading bytecode files
    touch src/gen/customRuntime
  '' + (if genBytecode then ''
    ${bqn-path} genRuntime ${mbqn-source}
  '' else ''
    cp ${cbqn-bytecode-files}/src/gen/{compiles,formatter,runtime0,runtime1,src} src/gen/
  '');

  installPhase = ''
     runHook preInstall

     mkdir -p $out/bin/
     cp BQN -t $out/bin/
     # note guard condition for case-insensitive filesystems
     [ -e $out/bin/bqn ] || ln -s $out/bin/BQN $out/bin/bqn
     [ -e $out/bin/cbqn ] || ln -s $out/bin/BQN $out/bin/cbqn

     runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/CBQN/";
    description = "BQN implementation in C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk ];
    platforms = platforms.all;
  };
}
# TODO: version cbqn-bytecode-files
# TODO: test suite
