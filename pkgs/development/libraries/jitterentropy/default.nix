{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jitterentropy";
<<<<<<< HEAD
  version = "3.4.1";
=======
  version = "3.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GSGlupTN1o8BbTN287beqYSRFDaXOk6SlIRvtjpvmhQ=";
=======
    hash = "sha256-go7eGwBoZ58LkgKL7t8oZSc1cFlE6fPOT/ML3Aa8+CM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ]; # avoid warnings

<<<<<<< HEAD
  # prevent jitterentropy from builtin strip to allow controlling this from the derivation's
  # settings. Also fixes a strange issue, where this strip may fail when cross-compiling.
  installFlags = [
    "INSTALL_STRIP=install"
=======
  installFlags = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
