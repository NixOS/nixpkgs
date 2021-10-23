# Based on
# https://gist.github.com/gosub/a42e265ec38d9df203d6

{ stdenv, lib, fetchgit,
  cmake,
  supercollider, fftw, libsndfile }:

stdenv.mkDerivation {

  name = "sc3-plugins";
  version = "3.11.1";

  meta = with lib; {
    description = "Synths and other tools for SuperCollider";
    homepage = "https://supercollider.github.io/";
    license = "GPL version 2.0";
    branch = "Version-3.11.1";
    platforms = lib.platforms.linux;
    maintainers = [ maintainers.jeffBrown ];
  };

  src = fetchgit {
    url = "https://github.com/supercollider/sc3-plugins";
    rev = "209cf4ffdcc9181b37aedbf4902e4b4d4090d505"; # This is an ordinary git commit hash, the one corresponding to tag "Version-3.11.1".
    sha256 = "1cy7g2mvmikml4dg6v4fzw6qr2yv9c94531iwxp501fr9j6z5jh8";
      # To determine this sha256 value, I first supplied a garbage one
      # and ran `nix-build -L` in the folder containing this file.
      # The resulting error suggested this one.
    fetchSubmodules = true;
  };

  buildInputs = [ cmake
                  supercollider
                  fftw
                  libsndfile ];

  cmakeFlags = [
    "-DSUPERNOVA=OFF"
    "-DSC_PATH=${supercollider}/include/SuperCollider"
    "-DFFTW3F_LIBRARY=${fftw}/lib/" ];
}
