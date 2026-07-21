{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # build-time
  cmake,
  xxd,
  which,

  # run-time
  readline,

  # tests
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenroom";
  version = "5.37.2";

  __structuredAttrs = true;
  dontUseCmakeConfigure = true; # cmake is a dependency, but we use make to build
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "Zenroom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gNUclaXF7C2yBywo1TAwHOfB9Pe17g6fCLhEcFq8JL0=";
    postFetch = ''
      # conflict on case-insensitive filesystems
      pushd $out/docs/examples/zencode_cookbook/cookbook_when
      rm *_move_as.out.json *_move_to.out.json
      popd
    '';
  };

  postPatch = ''
    patchShebangs build/embed-lualibs
  '';

  nativeBuildInputs = [
    cmake
    which # ar
    xxd
  ];

  buildInputs = [
    readline
  ];

  buildFlags =
    with stdenv.hostPlatform;
    lib.optionals (isLinux && !isMusl) [
      "linux-lib"
      "linux-exe"
    ]
    ++ lib.optionals (isLinux && isMusl) [
      "musl"
    ]
    ++ lib.optionals isDarwin [
      "osx-lib"
      "osx-exe"
    ]
    ++ lib.optionals (isUnix && !isLinux && !isDarwin) [
      "posix-lib"
      "posix-exe"
    ];

  hardeningDisable = [ "format" ]; # -Werror=format-security

  env.PREFIX = "";
  env.DESTDIR = placeholder "out";

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  postInstall = ''
    install -D libzenroom${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests = callPackage ./tests { zenroom = finalAttrs.finalPackage; };

  meta = {
    description = "no-code cryptographic virtual machine";
    longDescription = ''
      Zenroom is a tiny, portable, and fully isolated crypto VM for building
      privacy-preserving applications, smart contracts, and secure data
      workflows.
    '';
    homepage = "https://github.com/dyne/Zenroom";
    changelog = "https://github.com/dyne/Zenroom/blob/${finalAttrs.src.rev}/ChangeLog.md";
    mainProgram = "zenroom";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      agpl3Plus
      asl20 # lib/milagro-crypto-c, lib/mlkem, lib/longfellow-zk, lib/mayo
      bsd3 # lib/zstd
      cc0 # lib/pqclean, lib/ed25519-donna
      mit # lib/lua54, src/varint.*, lib/mayo
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
