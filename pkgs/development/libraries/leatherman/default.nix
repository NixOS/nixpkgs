{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.11.0";

  src = fetchFromGitHub {
    sha256 = "1kp35gnph9myqxdxzyj1871ay19nfajxglzwai1gvsnh5840xnxy";
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
    homepage = "https://github.com/puppetlabs/leatherman/";
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
