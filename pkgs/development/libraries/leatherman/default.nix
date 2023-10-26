{ lib, stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.12.10";

  src = fetchFromGitHub {
    sha256 = "sha256-0AHChU96LOVCsd+b77nKV4lOt1FtbVfv+OSNvGjekYo=";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  cmakeFlags = [ "-DLEATHERMAN_ENABLE_TESTING=OFF" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost curl ruby ];

  meta = with lib; {
    homepage = "https://github.com/puppetlabs/leatherman/";
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };

}
