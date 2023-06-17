{ fetchFromGitHub
, lib
, libffi
, libxml2
, llvmPackages_13
, ncurses
, rustPlatform
}:

rustPlatform.buildRustPackage {
  pname = "ante";
  version = "unstable-2022-08-22";
  src = fetchFromGitHub {
    owner = "jfecher";
    repo = "ante";
    rev = "8b708d549c213c34e4ca62d31cf0dd25bfa7b548";
    sha256 = "sha256-s8nDuG32lI4pBLsOzgfyUGpc7/r0j4EhzH54ErBK7A0=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "inkwell-0.1.0" = "sha256-vWrpF66r5HalGQz2jSmQljfz0EgS7shLw7A8q75j3tE=";
    };
  };

  /*
     https://crates.io/crates/llvm-sys#llvm-compatibility
     llvm-sys requires a specific version of llvmPackages,
     that is not the same as the one included by default with rustPlatform.
  */
  nativeBuildInputs = [ llvmPackages_13.llvm ];
  buildInputs = [ libffi libxml2 ncurses ];

  postPatch = ''
    substituteInPlace tests/golden_tests.rs --replace \
      'target/debug' "target/$(rustc -vV | sed -n 's|host: ||p')/release"
  '';
  preBuild =
    let
      major = lib.versions.major llvmPackages_13.llvm.version;
      minor = lib.versions.minor llvmPackages_13.llvm.version;
      llvm-sys-ver = "${major}${builtins.substring 0 1 minor}";
    in
    ''
      # On some architectures llvm-sys is not using the package listed inside nativeBuildInputs
      export LLVM_SYS_${llvm-sys-ver}_PREFIX=${llvmPackages_13.llvm.dev}
      export ANTE_STDLIB_DIR=$out/lib
      mkdir -p $ANTE_STDLIB_DIR
      cp -r $src/stdlib/* $ANTE_STDLIB_DIR
    '';

  meta = with lib; {
    homepage = "https://antelang.org/";
    description = "A low-level functional language for exploring refinement types, lifetime inference, and algebraic effects";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ehllie ];
  };
}
