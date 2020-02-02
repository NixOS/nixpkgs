{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.10.0";

  src = fetchFromGitHub {
    sha256 = "1kvvqvr0djz4gb770rs5h97zqcymvbzrmsw8kz2icvlmcicm7qd8";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = builtins.toString [
    "-Wno-error=ignored-qualifiers"
    "-Wno-error=class-memaccess"
    "-Wno-error=catch-value"
    "-Wno-error=deprecated-copy"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost curl ruby ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/leatherman/;
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
