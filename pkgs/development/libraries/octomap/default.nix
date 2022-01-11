{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "octomap";
  version = "1.9.7";

  src = fetchFromGitHub {
    owner = "OctoMap";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pb58w6vka7wzs533lcy7i6y5nwjfrzy6b35fhrb1dhq2mgszc79";
  };
  sourceRoot = "source/octomap";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
  };
}
