{ callPackage
, lib
, stdenv
, stdenvNoCC
, fetchFromGitHub
, genBytecode ? false
, bqn-path ? null
, mbqn-source ? null
, enableReplxx ? false
, enableSingeli ? stdenv.hostPlatform.avx2Support
  # No support for macOS' .dylib on the CBQN side
, enableLibcbqn ? stdenv.hostPlatform.isLinux
, libffi
, pkg-config
}:

let
  cbqn-bytecode-submodule =
    callPackage ./cbqn-bytecode.nix { inherit lib fetchFromGitHub stdenvNoCC; };
  replxx-submodule = callPackage ./replxx.nix { inherit lib fetchFromGitHub stdenvNoCC; };
  singeli-submodule = callPackage ./singeli.nix { inherit lib fetchFromGitHub stdenvNoCC; };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));

stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "unstable-2023-02-01";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "05c1270344908e98c9f2d06b3671c3646f8634c3";
    hash = "sha256-wKeyYWMgTZPr+Ienz3xnsXeD67vwdK4sXbQlW+GpQho=";
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
    (lib.flatten (if enableSingeli then ["o3n-singeli" "f='-mavx2'"] else ["o3"]))
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
    cp -r ${cbqn-bytecode-submodule}/dev/* build/bytecodeLocal/gen/
  '')
  + lib.optionalString enableReplxx ''
    cp -r ${replxx-submodule}/dev/* build/replxxLocal/
  ''
  + lib.optionalString enableSingeli ''
    cp -r ${singeli-submodule}/dev/* build/singeliLocal/
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
# TODO: test suite
