{ lib, stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jitterentropy";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${version}";
    hash = "sha256-CPvgc/W5Z2OfbP9Lp2tQevUQZr+xlh6q5r5Fp2WUHhg=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" ];

  hardeningDisable = [ "fortify" ]; # avoid warnings

  meta = with lib; {
    description = "Provides a noise source using the CPU execution timing jitter";
    homepage = "https://github.com/smuellerDD/jitterentropy-library";
    changelog = "https://github.com/smuellerDD/jitterentropy-library/raw/v${version}/CHANGES.md";
    license = with licenses; [ bsd3 /* OR */ gpl2Only ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ johnazoidberg c0bw3b ];
  };
}
