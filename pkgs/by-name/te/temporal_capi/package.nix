{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "temporal_capi";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "boa-dev";
    repo = "temporal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JmNYoskoQZewmWAU/SUBdjKdN+pnpMdLZUVv+jysS5A=";
  };

  cargoHash = "sha256-jIPbroAtS7D/l4QJtGCgXNa7QaQLdsF4Gh9O4NaRBCw=";

  postPatch = ''
    # Force crate-type to include staticlib
    echo '
    [lib]
    crate-type = ["${if stdenv.hostPlatform.isStatic then "staticlib" else "cdylib"}"]
    ' >> temporal_capi/Cargo.toml
  '';

  cargoBuildFlags = [
    "--package"
    "temporal_capi"
    "--features"
    "zoneinfo64,compiled_data"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/*/release/libtemporal_capi.* -t $out/lib

    install -Dm644 -t $out/include/temporal_rs \
      temporal_capi/bindings/cpp/temporal_rs/*.hpp
    install -Dm644 -t $out/include \
      temporal_capi/bindings/c/*.h

    runHook postInstall
  '';
  postInstall = ''
    mkdir $out/lib/pkgconfig
    cat -> $out/lib/pkgconfig/temporal_capi.pc <<EOF
    prefix=$out
    exec_prefix=''${prefix}
    libdir=''${exec_prefix}/lib
    includedir=''${prefix}/include

    Name: temporal_capi
    Description: C API for temporal_rs
    Version: ${finalAttrs.version}
    Libs: -L''${libdir} -ltemporal_capi
    Cflags: -I''${includedir}
    EOF
  '';
  postFixup = lib.optional (stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic) ''
    ${stdenv.cc.targetPrefix}install_name_tool -id "$out/lib/libtemporal_capi.dylib" "$out/lib/libtemporal_capi.dylib"
  '';

  # We don't want to run Rust checks, we only check the resulting lib using C/C++ in the installCheckPhase.
  doCheck = false;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ stdenv.cc ];
  installCheckPhase = ''
    runHook preInstallCheck

    cc -L $out/lib -I $out/include temporal_capi/tests/c/simple.c -ltemporal_capi -lm -o c_test
    ./c_test
    c++ -L $out/lib -I $out/include temporal_capi/tests/cpp/simple.cpp -ltemporal_capi -lm -o cpp_test
    ./cpp_test

    runHook postInstallCheck
  '';

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "temporal_capi" ];
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A Rust implementation of ECMAScript's Temporal API";
    homepage = "https://github.com/boa-dev/temporal";
    changelog = "https://github.com/boa-dev/temporal/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ aduh95 ];
  };
})
