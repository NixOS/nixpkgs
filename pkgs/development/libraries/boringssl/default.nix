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
  version = "2021-04-18";

  src = fetchgit {
    url    = "https://boringssl.googlesource.com/boringssl";
    rev    = "468cde90ca58421d63f4dfeaebcf8bb3fccb4127";
    sha256 = "0gaqcbvp6r5fq265mckmg0i0rjab0bhxkxcvfxp3ar5dm7q88w39";
  };

  nativeBuildInputs = [ cmake ninja perl ];

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  # hack to get both go and cmake configure phase
  # (if we use postConfigure then cmake will loop runHook postConfigure)
  preBuild = ''
    cmakeConfigurePhase
  '';

  buildPhase = ''
    ninjaBuildPhase
  '';

  # CMAKE_OSX_ARCHITECTURES is set to x86_64 by Nix, but it confuses boringssl on aarch64-linux.
  cmakeFlags = [ "-GNinja" ] ++ lib.optionals (stdenv.isLinux) [ "-DCMAKE_OSX_ARCHITECTURES=" ];

  installPhase = ''
    mkdir -p $bin/bin $out/include $out/lib

    mv tool/bssl $bin/bin

    mv ssl/libssl.a           $out/lib
    mv crypto/libcrypto.a     $out/lib
    mv decrepit/libdecrepit.a $out/lib

    mv ../include/openssl $out/include
  '';

  outputs = [ "out" "bin" ];

  meta = with lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "https://boringssl.googlesource.com";
    platforms   = platforms.all;
    maintainers = [ maintainers.thoughtpolice ];
    license = with licenses; [ openssl isc mit bsd3 ];
  };
}
