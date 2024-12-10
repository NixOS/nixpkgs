{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  perl,
  buildGoModule,
}:

# reference: https://boringssl.googlesource.com/boringssl/+/2661/BUILDING.md
buildGoModule {
  pname = "boringssl";
  version = "unstable-2024-02-15";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    rev = "5a1a5fbdb865fa58f1da0fd8bf6426f801ea37ac";
    hash = "sha256-nu+5TeWEAVLGhTE15kxmTWZxo0V2elNUy67gdaU3Y+I=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    perl
  ];

  vendorHash = "sha256-074bgtoBRS3SOxLrwZbBdK1jFpdCvF6tRtU1CkrhoDY=";
  proxyVendor = true;

  # hack to get both go and cmake configure phase
  # (if we use postConfigure then cmake will loop runHook postConfigure)
  preBuild =
    ''
      cmakeConfigurePhase
    ''
    + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      export GOARCH=$(go env GOHOSTARCH)
    '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12 but breaks on darwin (with clang)
      "-Wno-error=stringop-overflow"
    ]
  );

  buildPhase = ''
    ninjaBuildPhase
  '';

  # CMAKE_OSX_ARCHITECTURES is set to x86_64 by Nix, but it confuses boringssl on aarch64-linux.
  cmakeFlags = [ "-GNinja" ] ++ lib.optionals (stdenv.isLinux) [ "-DCMAKE_OSX_ARCHITECTURES=" ];

  installPhase = ''
    mkdir -p $bin/bin $dev $out/lib

    mv tool/bssl $bin/bin

    mv ssl/libssl.a           $out/lib
    mv crypto/libcrypto.a     $out/lib
    mv decrepit/libdecrepit.a $out/lib

    mv ../include $dev
  '';

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  meta = with lib; {
    description = "Free TLS/SSL implementation";
    mainProgram = "bssl";
    homepage = "https://boringssl.googlesource.com";
    maintainers = [ maintainers.thoughtpolice ];
    license = with licenses; [
      openssl
      isc
      mit
      bsd3
    ];
  };
}
