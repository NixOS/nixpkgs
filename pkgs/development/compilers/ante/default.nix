{ fetchFromGitHub
, installShellFiles
, lib
, libffi
, libxml2
, llvmPackages # By default this is llvmPackages_13 from the callPackage call
, ncurses
, rustPlatform
}:

rustPlatform.buildRustPackage {
  pname = "ante";
  version = "unstable-2022-10-06";
  src = fetchFromGitHub {
    owner = "jfecher";
    repo = "ante";
    rev = "867cfea7334a241908207dc665f6614e07b77b77";
    sha256 = "plXwewVYF/E7SO1qHFA/MhvCP0iWB1V/i1RbmuzNFlk=";
  };
  cargoSha256 = "NwK8BbXFneemfFFa9oxGzmxZ3QCzon3TKNCilhK3yR8=";

  /*
     https://crates.io/crates/llvm-sys#llvm-compatibility
     llvm-sys requires a specific version of llvmPackages,
     that is not the same as the one included by default with rustPlatform.
  */
  nativeBuildInputs = [ llvmPackages.llvm installShellFiles ];
  buildInputs = [ libffi libxml2 ncurses ];

  postPatch = ''
    substituteInPlace tests/golden_tests.rs --replace \
      'target/debug' "target/$(rustc -vV | sed -n 's|host: ||p')/release"
  '';

  preBuild =
    let
      major = lib.versions.major llvmPackages.llvm.version;
      minor = lib.versions.minor llvmPackages.llvm.version;
      llvm-sys-ver = "${major}${builtins.substring 0 1 minor}";
    in
    ''
      # On some architectures llvm-sys is not using the package listed inside nativeBuildInputs
      export LLVM_SYS_${llvm-sys-ver}_PREFIX=${llvmPackages.llvm.dev}
      export ANTE_STDLIB_DIR=$out/lib
      mkdir -p $ANTE_STDLIB_DIR
      cp -r $src/stdlib/* $ANTE_STDLIB_DIR
    '';

  postInstall = ''
    installShellCompletion --cmd ante \
      --bash <($out/bin/ante --shell-completion bash) \
      --fish <($out/bin/ante --shell-completion fish) \
      --zsh <($out/bin/ante --shell-completion zsh)
  '';

  meta = with lib; {
    homepage = "https://antelang.org/";
    description = "A low-level functional language for exploring refinement types, lifetime inference, and algebraic effects";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ehllie ];
  };
}
