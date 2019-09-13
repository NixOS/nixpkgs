{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  pname = "libwhereami";
  version = "0.2.2";

  src = fetchFromGitHub {
    sha256 = "084n153jaq8fmhjififk0xlx1d1i3lclnw2j3ly8bixvc392vzly";
    rev = version;
    repo = "libwhereami";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=catch-value" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Library to report hypervisor information from inside a VM";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
    badPlatforms = platforms.arm;
  };

}
