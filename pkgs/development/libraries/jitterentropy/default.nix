{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jitterentropy";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${version}";
    hash = "sha256-go7eGwBoZ58LkgKL7t8oZSc1cFlE6fPOT/ML3Aa8+CM=";
  };

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ]; # avoid warnings

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Provides a noise source using the CPU execution timing jitter";
    homepage = "https://github.com/smuellerDD/jitterentropy-library";
    changelog = "https://github.com/smuellerDD/jitterentropy-library/raw/v${version}/CHANGES.md";
    license = with licenses; [ bsd3 /* OR */ gpl2Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ johnazoidberg c0bw3b ];
  };
}
