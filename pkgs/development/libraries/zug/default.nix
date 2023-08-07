{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "zug";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "zug";
    rev = "v${version}";
    hash = "sha256-7xTMDhPIx1I1PiYNanGUsK8pdrWuemMWM7BW+NQs2BQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Transducers for C++ — Clojure style higher order push/pull sequence transformations";
    homepage = "https://github.com/arximboldi/zug";
    changelog = "https://github.com/arximboldi/zug/releases/tag/v${version}";
    license = licenses.boost;
    maintainers = with maintainers; [ sifmelcara ];
    platforms = platforms.all;
  };
}
