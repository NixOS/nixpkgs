{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  name = "libwhereami-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    sha256 = "0nhbmxm626cgawprszw6c03a3hasxjn1i9ldhhj5xyvxp8r5l9q4";
    rev = version;
    repo = "libwhereami";
    owner = "puppetlabs";
  };

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
