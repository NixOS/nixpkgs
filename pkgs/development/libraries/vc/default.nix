{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "Vc-${version}";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = version;
    sha256 = "0y4riz2kiw6a9w2zydj6x0vhy2qc9v17wspq3n2q88nbas72yd2m";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -i '/OptimizeForArchitecture()/d' cmake/VcMacros.cmake
    sed -i '/AutodetectHostArchitecture()/d' print_target_architecture.cmake
  '';

  meta = with stdenv.lib; {
    description = "Library for multiprecision complex arithmetic with exact rounding";
    homepage = https://github.com/VcDevel/Vc;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
