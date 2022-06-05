{ lib
, stdenv
, fetchFromGitea
, autoreconfHook
, geos
}:

stdenv.mkDerivation rec {
  pname = "librttopo";
  version = "1.1.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitea {
    domain = "git.osgeo.org/gitea";
    owner = "rttopo";
    repo = "librttopo";
    rev = "librttopo-${version}";
    sha256 = "0h7lzlkn9g4xky6h81ndy0aa6dxz8wb6rnl8v3987jy1i6pr072p";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ geos ];

  meta = with lib; {
    description = "RT Topology Library";
    homepage = "https://git.osgeo.org/gitea/rttopo/librttopo";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
