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
    rev = "b000b951aa8f3590b196b4c09056604c0b32a168";
    hash = "sha256-znW0xOXogP4TfifUmk3cs4aN/9mMSpSD2WJppmeI1Fg=";
  };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));

stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "0.pre+date=2021-12-13";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "e7662b0f6a44add0749fba2a6d7309a5c1eb2601";
    hash = "sha256-2nfkTZBIGHX5cok6Ea3KSewakZy8Ey8nSO2Fe4xGgvg=";
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
     # note guard condition for case-insensitive filesystems
     [ -e $out/bin/bqn ] || ln -s $out/bin/BQN $out/bin/bqn
     [ -e $out/bin/cbqn ] || ln -s $out/bin/BQN $out/bin/cbqn

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
