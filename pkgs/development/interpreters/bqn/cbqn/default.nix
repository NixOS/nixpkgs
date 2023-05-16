{ callPackage
, lib
, stdenv
, stdenvNoCC
, fetchFromGitHub
, fixDarwinDylibNames
, genBytecode ? false
, bqn-path ? null
<<<<<<< HEAD
, mbqn-source
, enableReplxx ? false
=======
, mbqn-source ? null
, enableReplxx ? false
, enableSingeli ? stdenv.hostPlatform.avx2Support
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-LoxwNxuadbYJgIkr1+bZoErTc9WllN2siAsKnxoom3Y=";
=======
    hash = "sha256-M9GTsm65DySLcMk9QDEhImHnUvWtYGPwiG657wHg3KA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    libffi
  ];

  dontConfigure = true;
<<<<<<< HEAD
  doInstallCheck = true;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    sed -i '/SHELL =.*/ d' makefile
    patchShebangs build/build
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  buildFlags = [
    # interpreter binary
<<<<<<< HEAD
    "o3"
    "notui=1" # display build progress in a plain-text format
    "REPLXX=${if enableReplxx then "1" else "0"}"
  ] ++ lib.optionals stdenv.hostPlatform.avx2Support [
    "has=avx2"
=======
    (lib.flatten (if enableSingeli then ["o3n-singeli" "f='-mavx2'"] else ["o3"]))
    "REPLXX=${if enableReplxx then "1" else "0"}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals enableLibcbqn [
    # embeddable interpreter as a shared lib
    "shared-o3"
  ];

  preBuild = ''
    # Purity: avoids git downloading bytecode files
    mkdir -p build/bytecodeLocal/gen
<<<<<<< HEAD
    cp -r ${singeli-submodule}/dev/* build/singeliLocal/
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '' + (if genBytecode then ''
    ${bqn-path} ./build/genRuntime ${mbqn-source} build/bytecodeLocal/
  '' else ''
    cp -r ${cbqn-bytecode-submodule}/dev/* build/bytecodeLocal/gen/
  '')
  + lib.optionalString enableReplxx ''
    cp -r ${replxx-submodule}/dev/* build/replxxLocal/
<<<<<<< HEAD
  '';
=======
  ''
  + lib.optionalString enableSingeli ''
    cp -r ${singeli-submodule}/dev/* build/singeliLocal/
 '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
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

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/dzaima/CBQN/";
    description = "BQN implementation in C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk detegr ];
    platforms = platforms.all;
  };
}
<<<<<<< HEAD
=======
# TODO: test suite
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
