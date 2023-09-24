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

  buildInputs = lib.optionals enableOpenMP [ llvmPackages.openmp ];

  cmakeFlags = [ "-DOPENMP=${if enableOpenMP then "ON" else "OFF"}" ];

  meta = with lib; {
    description = "Wavefront alignment algorithm library v2";
    homepage = "https://github.com/smarco/WFA2-lib";
    license = licenses.mit;
    maintainers = with maintainers; [ rs0vere ];
    platforms = platforms.linux;
  };
}
