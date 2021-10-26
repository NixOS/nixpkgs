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
    rev = "4d23479cdbd5ac6eb512c376ade58077b814b2b7";
    hash = "sha256-MTvg4lOB26bqvJTqV71p4Y4qDjTYaOE40Jk4Sle/hsY=";
  };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));

stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "0.pre+unstable=2021-10-09";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "debc4e2afe313a3c54133df9f26969c2927dc8aa";
    hash = "sha256-ixFDmtq6hd2enmPbBT0JCv1bmxt84zle4zPQzz+rMCI=";
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
    cp ${cbqn-bytecode-files}/src/gen/{compiler,formatter,runtime0,runtime1,src} src/gen/
  '');

  installPhase = ''
     runHook preInstall

     mkdir -p $out/bin/
     cp BQN -t $out/bin/
     ln -s $out/bin/BQN $out/bin/bqn
     ln -s $out/bin/BQN $out/bin/cbqn

     runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/CBQN/";
    description = "BQN implementation in C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica ];
    platforms = platforms.all;
  };
}
# TODO: version cbqn-bytecode-files
# TODO: test suite
