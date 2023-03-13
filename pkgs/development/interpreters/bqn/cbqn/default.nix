{ lib
, stdenv
, fetchFromGitHub
, genBytecode ? false
, bqn-path ? null
, mbqn-source ? null
, enableReplxx ? false
  # No support for macOS' .dylib on the CBQN side
, enableLibcbqn ? stdenv.hostPlatform.isLinux
, libffi
, pkg-config
}:

let
  # TODO: these submodules should be separated libraries
  cbqn-bytecode-files = fetchFromGitHub {
    name = "cbqn-bytecode-files";
    owner = "dzaima";
    repo = "CBQN";
    rev = "3df8ae563a626ff7ae0683643092f0c3bc2481e5";
    hash = "sha256:0rh9qp1bdm9aa77l0kn9n4jdy08gl6l7898lncskxiq9id6xvyb8";
  };
  replxx-submodule = fetchFromGitHub {
    name = "replxx-submodule";
    owner = "dzaima";
    repo = "replxx";
    rev = "ba94c293caad52486df8712e808783df9a8f4501";
    hash = "sha256-pMLvURksj/5k5b6BTwWxjomoROMOE5+GRjyaoqu/iYE=";
  };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));

stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "0.pre+date=2022-11-27";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "49c0d9a355698f54fff2c0caa177e2b341fabb45";
    hash = "sha256-jm2ZzFxhr9o4nFR2rjYJz/4GH+WFnfU4QDovrOPI3jQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libffi
  ];

  dontConfigure = true;

  postPatch = ''
    sed -i '/SHELL =.*/ d' makefile
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.optional enableReplxx "REPLXX=1";

  buildFlags = [
    # interpreter binary
    "o3"
  ] ++ lib.optionals enableLibcbqn [
    # embeddable interpreter as a shared lib
    "shared-o3"
  ];

  preBuild = ''
    # Purity: avoids git downloading bytecode files
    mkdir -p build/bytecodeLocal/gen
  '' + (if genBytecode then ''
    ${bqn-path} ./build/genRuntime ${mbqn-source} build/bytecodeLocal/
  '' else ''
    cp ${cbqn-bytecode-files}/src/gen/{compiles,explain,formatter,runtime0,runtime1,src} build/bytecodeLocal/gen/
  '')
  + lib.optionalString enableReplxx ''
    cp -r ${replxx-submodule} build/replxxLocal/
  '';

  outputs = [
    "out"
  ] ++ lib.optionals enableLibcbqn [
    "lib"
    "dev"
  ];

  installPhase = ''
     runHook preInstall

     mkdir -p $out/bin/
     cp BQN -t $out/bin/
     # note guard condition for case-insensitive filesystems
     [ -e $out/bin/bqn ] || ln -s $out/bin/BQN $out/bin/bqn
     [ -e $out/bin/cbqn ] || ln -s $out/bin/BQN $out/bin/cbqn
  ''
  + lib.optionalString enableLibcbqn ''
     install -Dm644 include/bqnffi.h -t "$dev/include"
     install -Dm755 libcbqn${stdenv.hostPlatform.extensions.sharedLibrary} -t "$lib/lib"
  ''
  + ''
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
