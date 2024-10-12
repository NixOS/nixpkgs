{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jitterentropy";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${version}";
    hash = "sha256-CPvgc/W5Z2OfbP9Lp2tQevUQZr+xlh6q5r5Fp2WUHhg=";
  };

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ]; # avoid warnings

  # prevent jitterentropy from builtin strip to allow controlling this from the derivation's
  # settings. Also fixes a strange issue, where this strip may fail when cross-compiling.
  installFlags = [
    "INSTALL_STRIP=install"
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
