{ lib, stdenv, fetchFromGitHub, cmake, openssl, popt, xmlto }:

stdenv.mkDerivation rec {
  pname = "rabbitmq-c";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "alanxz";
    repo = "rabbitmq-c";
    rev = "v${version}";
    sha256 = "sha256-4tSZ+eaLZAkSmFsGnIrRXNvn3xA/4sTKyYZ3hPUMcd0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl popt xmlto ];

  # https://github.com/alanxz/rabbitmq-c/issues/733
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '\$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = with lib; {
    description = "RabbitMQ C AMQP client library";
    homepage = "https://github.com/alanxz/rabbitmq-c";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
