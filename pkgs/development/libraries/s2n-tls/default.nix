{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, openssl
}:

stdenv.mkDerivation rec {
  pname = "s2n-tls";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6XqBpNURU8fzGkTt4jsijgMiOkzMebmLmPAq8yQsTg4=";
  };

  patches = [
    # Fix FindLibCrypto paths (https://github.com/aws/s2n-tls/pull/3067)
    (fetchpatch {
      url = "https://github.com/aws/s2n-tls/commit/bda649524402be4018c44bff07f6c64502a351ec.patch";
      sha256 = "02jmxsrd506vhjzlrgh1p2z1f1sn4v8klks25zisiykyqkyaczkv";
    })
  ];

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev"];

  buildInputs = [ openssl ]; # s2n-config has find_dependency(LibCrypto).

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DUNSAFE_TREAT_WARNINGS_AS_ERRORS=OFF" # disable -Werror
  ];

  propagatedBuildInputs = [ openssl ]; # s2n-config has find_dependency(LibCrypto).

  postInstall = ''
    # Glob for 'shared' or 'static' subdir
    for f in $out/lib/s2n/cmake/*/s2n-targets.cmake; do
      substituteInPlace "$f" \
        --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES ""'
    done
  '';

  meta = with lib; {
    description = "C99 implementation of the TLS/SSL protocols";
    homepage = "https://github.com/aws/s2n-tls";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
