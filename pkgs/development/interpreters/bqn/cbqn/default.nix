{
  lib,
  callPackage,
  fixDarwinDylibNames,
  libffi,
  mbqn-source,
  pkg-config,
  stdenv,
  # Boolean flags
  enableReplxx ? false,
  enableLibcbqn ? ((stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin) && !enableReplxx),
  generateBytecode ? false,
  # "Configurable" options
  bqn-interpreter,
}:

let
  sources = callPackage ./sources.nix { };
in
stdenv.mkDerivation {
  pname = "cbqn" + lib.optionalString (!generateBytecode) "-standalone";
  inherit (sources.cbqn) version src;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    libffi
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  buildFlags = [
    # interpreter binary
    "o3"
    "notui=1" # display build progress in a plain-text format
    "REPLXX=${if enableReplxx then "1" else "0"}"
  ]
  ++ lib.optionals stdenv.hostPlatform.avx2Support [
    "has=avx2"
  ]
  ++ lib.optionals enableLibcbqn [
    # embeddable interpreter as a shared lib
    "shared-o3"
  ];

  outputs = [
    "out"
  ]
  ++ lib.optionals enableLibcbqn [
    "lib"
    "dev"
  ];

  dontConfigure = true;

  doInstallCheck = true;

  strictDeps = true;

  postPatch = ''
    sed -i '/SHELL =.*/ d' makefile
    patchShebangs build/build
  '';

  preBuild = ''
    mkdir -p build/singeliLocal/
    cp -r ${sources.singeli.src}/* build/singeliLocal/
  ''
  + (
    if generateBytecode then
      ''
        mkdir -p build/bytecodeLocal/gen
        ${bqn-interpreter} ./build/genRuntime ${mbqn-source} build/bytecodeLocal/
      ''
    else
      ''
        mkdir -p build/bytecodeLocal/gen
        cp -r ${sources.cbqn-bytecode.src}/* build/bytecodeLocal/
      ''
  )
  + lib.optionalString enableReplxx ''
    mkdir -p build/replxxLocal/
    cp -r ${sources.replxx.src}/* build/replxxLocal/
  '';

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

  installCheckPhase = ''
    runHook preInstallCheck

    # main test suite from mlochbaum/BQN
    $out/bin/BQN ${mbqn-source}/test/this.bqn

    # CBQN tests that do not require compiling with test-only flags
    $out/bin/BQN test/cmp.bqn
    $out/bin/BQN test/equal.bqn
    $out/bin/BQN test/copy.bqn
    $out/bin/BQN test/bit.bqn
    $out/bin/BQN test/hash.bqn
    $out/bin/BQN test/squeezeValid.bqn
    $out/bin/BQN test/squeezeExact.bqn
    $out/bin/BQN test/various.bqn
    $out/bin/BQN test/random.bqn

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/dzaima/CBQN/";
    description = "BQN implementation in C";
    license = with lib.licenses; [
      # https://github.com/dzaima/CBQN?tab=readme-ov-file#licensing
      asl20
      boost
      gpl3Only
      lgpl3Only
      mit
      mpl20
    ];
    mainProgram = "cbqn";
    maintainers = with lib.maintainers; [
      detegr
      shnarazk
      sternenseemann
      synthetica
    ];
    platforms = lib.platforms.all;
  };
}
