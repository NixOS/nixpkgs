{
  lib,
  stdenv,
  cargo,
  makeWrapper,
  rustPlatform,
  rustc,
  asNightly ? false,
}:

rustPlatform.buildRustPackage {
  pname = "rustfmt" + lib.optionalString asNightly "-nightly";
  inherit (rustc) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  buildAndTestSubdir = "src/tools/rustfmt";

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    rustc.llvm
  ];

  # rustfmt uses the rustc_driver and std private libraries, and Rust's build process forces them to have
  # an install name of `@rpath/...` [0] [1] instead of the standard on macOS, which is an absolute path
  # to itself.
  #
  # [0]: https://github.com/rust-lang/rust/blob/f77f4d55bdf9d8955d3292f709bd9830c2fdeca5/src/bootstrap/builder.rs#L1543
  # [1]: https://github.com/rust-lang/rust/blob/f77f4d55bdf9d8955d3292f709bd9830c2fdeca5/compiler/rustc_codegen_ssa/src/back/linker.rs#L323-L331
  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath "${rustc.unwrapped}/lib" "$out/bin/rustfmt"
    install_name_tool -add_rpath "${rustc.unwrapped}/lib" "$out/bin/git-rustfmt"
  '';

  # As of 1.0.0 and rustc 1.30 rustfmt requires a nightly compiler
  RUSTC_BOOTSTRAP = 1;

  # As of rustc 1.45.0, these env vars are required to build rustfmt (due to
  # https://github.com/rust-lang/rust/pull/72001)
  CFG_RELEASE = rustc.version;
  CFG_RELEASE_CHANNEL = if asNightly then "nightly" else "stable";

  env = lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) {
    # error: install_name_tool: changing install names or rpaths can't be redone for: /nix/store/.../bin/rustfmt
    # (for architecture x86_64) because larger updated load commands do not fit (the program must
    # be relinked, and you may need to use -headerpad or -headerpad_max_install_names)
    NIX_LDFLAGS = "-headerpad_max_install_names";
  };

  postInstall = ''
    wrapProgram $out/bin/cargo-fmt \
      --suffix PATH : ${lib.makeBinPath [ cargo ]}
  '';

  meta = with lib; {
    description = "Tool for formatting Rust code according to style guidelines";
    homepage = "https://github.com/rust-lang-nursery/rustfmt";
    license = with licenses; [
      mit
      asl20
    ];
    mainProgram = "rustfmt";
    maintainers = with maintainers; [
      globin
      basvandijk
    ];
  };
}
