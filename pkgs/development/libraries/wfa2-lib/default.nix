{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, llvmPackages
, enableOpenMP ? true
}:

stdenv.mkDerivation rec {
  pname = "wfa2-lib";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "smarco";
    repo = "WFA2-lib";
    rev = "v${version}";
    hash = "sha256-PLZhxKMBhKm6E/ENFZ/yWMWIwJG5voaJls2in44OGoQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optional enableOpenMP [ llvmPackages.openmp ];

  cmakeFlags = lib.optional enableOpenMP [ "-DOPENMP=ON" ];

  meta = with lib; {
    homepage = "https://github.com/smarco/WFA2-lib";
    description = "Wavefront alignment algorithm library v2";
    license = licenses.mit;
    maintainers = with maintainers; [ ee2500 ];
    platforms = platforms.all;
  };
}
