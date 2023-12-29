{ lib
, stdenv
, fetchgit
, cmake
, ninja
, perl
, buildGoModule
}:

# reference: https://boringssl.googlesource.com/boringssl/+/2661/BUILDING.md
buildGoModule {
  pname = "boringssl";
  version = "unstable-2023-09-27";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    rev = "d24a38200fef19150eef00cad35b138936c08767";
    hash = "sha256-FBQ7y4N2rCM/Cyd6LBnDUXpSa2O3osUXukECTBjZL6s=";
  };

  nativeBuildInputs = [ cmake ninja perl ];

  vendorHash = "sha256-EJPcx07WuvHPAgiS1ASU6WHlHkxjUOO72if4TkmrqwY=";
  proxyVendor = true;

  # hack to get both go and cmake configure phase
  # (if we use postConfigure then cmake will loop runHook postConfigure)
  preBuild = ''
    cmakeConfigurePhase
  '' + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export GOARCH=$(go env GOHOSTARCH)
  '';

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [
    # Needed with GCC 12 but breaks on darwin (with clang)
    "-Wno-error=stringop-overflow"
  ]);

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

  outputs = [ "out" "bin" "dev" ];

  meta = with lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "https://boringssl.googlesource.com";
    maintainers = [ maintainers.thoughtpolice ];
    license = with licenses; [ openssl isc mit bsd3 ];
  };
}
