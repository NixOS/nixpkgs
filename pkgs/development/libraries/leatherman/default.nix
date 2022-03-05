{ lib, stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.12.7";

  src = fetchFromGitHub {
    sha256 = "sha256-a79/seKO6Efn6g4RWdqsP83pL5AIBAp1InjnMdOs3Qk=";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

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
