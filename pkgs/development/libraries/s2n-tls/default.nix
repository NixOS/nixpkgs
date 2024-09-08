{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, nix
}:

stdenv.mkDerivation rec {
  pname = "s2n-tls";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "s2n-tls";
    rev = "v${version}";
    hash = "sha256-BHDMYOHidwF6ssqSnpokXc/OwGrQNoUVb0/ubwhyiDM=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" ];

  buildInputs = [ openssl ]; # s2n-config has find_dependency(LibCrypto).

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUNSAFE_TREAT_WARNINGS_AS_ERRORS=OFF" # disable -Werror
  ] ++ lib.optionals stdenv.hostPlatform.isMips64 [
    # See https://github.com/aws/s2n-tls/issues/1592 and https://github.com/aws/s2n-tls/pull/1609
    "-DS2N_NO_PQ=ON"
  ];

  propagatedBuildInputs = [ openssl ]; # s2n-config has find_dependency(LibCrypto).

  postInstall = ''
    # Glob for 'shared' or 'static' subdir
    for f in $out/lib/s2n/cmake/*/s2n-targets.cmake; do
      substituteInPlace "$f" \
        --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES ""'
    done
  '';

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "C99 implementation of the TLS/SSL protocols";
    homepage = "https://github.com/aws/s2n-tls";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
