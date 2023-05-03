{ callPackage
, lib
, stdenv
, stdenvNoCC
, fetchFromGitHub
, fixDarwinDylibNames
, genBytecode ? false
, bqn-path ? null
, mbqn-source ? null
, enableReplxx ? false
, enableSingeli ? stdenv.hostPlatform.avx2Support
, enableLibcbqn ? ((stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin) && !enableReplxx)
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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "v${version}";
    hash = "sha256-M9GTsm65DySLcMk9QDEhImHnUvWtYGPwiG657wHg3KA=";
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    libffi
  ];

  dontConfigure = true;

  postPatch = ''
    sed -i '/SHELL =.*/ d' makefile
    patchShebangs build/build
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
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk detegr ];
    platforms = platforms.all;
  };
}
# TODO: test suite
