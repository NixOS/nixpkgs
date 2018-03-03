{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  name = "libwhereami-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    sha256 = "10phq4a11m8ly6b4dc2yg3dnjzg8ad5wnjv0ilvwylnw32800pxr";
    rev = version;
    repo = "libwhereami";
    owner = "puppetlabs";
  };

  # post gcc7, upstream bug: https://tickets.puppetlabs.com/browse/FACT-1828
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Library to report hypervisor information from inside a VM";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
