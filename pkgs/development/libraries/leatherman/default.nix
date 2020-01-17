{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.9.1";

  src = fetchFromGitHub {
    sha256 = "1aij0prpf7rvxx25qjf1krf0szb922hq9m6q58p90f5bjgymfzwh";
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
