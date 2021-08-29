{ lib, stdenv, fetchFromGitHub, cmake, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "nvidia-texture-tools";
  version = "unstable-2019-10-27";

  src = fetchFromGitHub {
    owner = "castano";
    repo = "nvidia-texture-tools";
    rev = "a131e4c6b0b7c9c73ccc3c9e6f1c7e165be86bcc";
    sha256 = "1qzyr3ib5dpxyq1y33lq02qv4cww075sm9bm4f651d34q5x38sk3";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/castano/nvidia-texture-tools/commit/6474f2593428d89ec152da2502aa136ababe66ca.patch";
      sha256 = "0akbkvm55hiv58jx71h9hj173rbnqlb5a430y9azjiix7zga42vd";
    })
  ];

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" "lib" ];

  postPatch = ''
    # Make a recently added pure virtual function just virtual,
    # to keep compatibility.
    sed -i 's/virtual void endImage() = 0;/virtual void endImage() {}/' src/nvtt/nvtt.h
  '';

  cmakeFlags = [
    "-DNVTT_SHARED=TRUE"
  ];

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$lib"
  '';

  meta = with lib; {
    description = "A set of cuda-enabled texture tools and compressors";
    homepage = "https://github.com/castano/nvidia-texture-tools";
    license = licenses.mit;
    platforms = platforms.unix;
    broken = stdenv.isAarch64;
  };
}
