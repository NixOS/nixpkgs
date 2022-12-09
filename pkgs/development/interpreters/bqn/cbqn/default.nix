{ lib
, stdenv
, fetchFromGitHub
, genBytecode ? false
, bqn-path ? null
, mbqn-source ? null
, libffi
, pkg-config
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
  version = "0.pre+date=2022-11-27";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "dbc7c83f7085d05e87721bedf1ee38931f671a8e";
    hash = "sha256:0nal1fs9y7nyx4d5q1qw868lxk7mivzw2y16wc3hw97pq4qf0dpb";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  # TODO(@sternenseemann): allow building against dzaima's replxx fork
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
    mkdir -p build/bytecodeLocal/gen
  '' + (if genBytecode then ''
    ${bqn-path} ./build/genRuntime ${mbqn-source} build/bytecodeLocal/
  '' else ''
    cp ${cbqn-bytecode-files}/src/gen/{compiles,explain,formatter,runtime0,runtime1,src} build/bytecodeLocal/gen/
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
