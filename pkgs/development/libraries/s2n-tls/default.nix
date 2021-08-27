{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "s2n-tls";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6XqBpNURU8fzGkTt4jsijgMiOkzMebmLmPAq8yQsTg4=";
  };

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
    substituteInPlace $out/lib/s2n/cmake/shared/s2n-targets.cmake \
      --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES ""'
  '';

  meta = with lib; {
    description = "C99 implementation of the TLS/SSL protocols";
    homepage = "https://github.com/aws/s2n-tls";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
