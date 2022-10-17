{ lib
, stdenv
, fetchFromGitHub
, genBytecode ? false
, bqn-path ? null
, mbqn-source ? null
, libffi
}:

let
  cbqn-bytecode-files = fetchFromGitHub {
    name = "cbqn-bytecode-files";
    owner = "dzaima";
    repo = "CBQN";
    rev = "3df8ae563a626ff7ae0683643092f0c3bc2481e5";
    hash = "sha256:0rh9qp1bdm9aa77l0kn9n4jdy08gl6l7898lncskxiq9id6xvyb8";
  };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));

stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "0.pre+date=2022-10-04";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "abcb575a537712763e9e53b6cb0eb415346b00e6";
    hash = "sha256:05gqw2ppcykv36ji8mkp8mq502q84vk9algp9c2d3z495xqy8rn6";
  };

  buildInputs = [
    libffi
  ];

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
    cp ${cbqn-bytecode-files}/src/gen/{compiles,explain,formatter,runtime0,runtime1,src} src/gen/
  '')
  # Need to adjust ld flags for darwin manually
  # https://github.com/dzaima/CBQN/issues/26
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeFlagsArray+=(LD_LIBS="-ldl -lffi")
  '';

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
