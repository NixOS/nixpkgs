{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.8.0";

  src = fetchFromGitHub {
    sha256 = "0iizy20pdkbnsfj6bzrkkj7faizc85lcpkpandvnxfybiq7j60iw";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=ignored-qualifiers" "-Wno-error=class-memaccess" "-Wno-error=catch-value" ];

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
