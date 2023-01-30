{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "googletest";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v${version}";
    sha256 = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/google/googletest";
    description = "Google Testing and Mocking Framework";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
