{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "sptk";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "sp-nitech";
    repo = "SPTK";
    rev = "v${version}";
    hash = "sha256-t8XVdKrrewfqefUnEz5xHgRHF0NThNQD1KGPMLOO/o8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = with lib; {
    changelog = "https://github.com/sp-nitech/SPTK/releases/tag/v${version}";
    description = "Suite of speech signal processing tools";
    homepage = "https://github.com/sp-nitech/SPTK";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
