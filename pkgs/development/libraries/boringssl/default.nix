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
  version = "2021-07-09";

  src = fetchgit {
    url    = "https://boringssl.googlesource.com/boringssl";
    rev    = "268a4a6ff3bd656ae65fe41ef1185daa85cfae21";
    sha256 = "04fja4fdwhc69clmvg8i12zm6ks3sfl3r8i5bxn4x63b9dj5znlx";
  };

  nativeBuildInputs = [ cmake ninja perl ];

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  # hack to get both go and cmake configure phase
  # (if we use postConfigure then cmake will loop runHook postConfigure)
  preBuild = ''
    cmakeConfigurePhase
  '' + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export GOARCH=$(go env GOHOSTARCH)
  '';

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
