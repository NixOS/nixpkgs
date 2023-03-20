{ lib, stdenv, fetchFromGitHub, cmake, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "nvidia-texture-tools";
  version = "unstable-2020-12-21";

  src = fetchFromGitHub {
    owner = "castano";
    repo = "nvidia-texture-tools";
    rev = "aeddd65f81d36d8cb7b169b469ef25156666077e";
    sha256 = "sha256-BYNm8CxPQbfmnnzNmOQ2Dc8HSyO8mkqzYsBZ5T80398=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" "lib" ];

  postPatch = ''
    # Make a recently added pure virtual function just virtual,
    # to keep compatibility.
    sed -i 's/virtual void endImage() = 0;/virtual void endImage() {}/' src/nvtt/nvtt.h
  '' + lib.optionalString stdenv.isAarch64 ''
    # remove x86_64-only libraries
    sed -i '/bc1enc/d' src/nvtt/tests/CMakeLists.txt
    sed -i '/libsquish/d;/CMP_Core/d' extern/CMakeLists.txt
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
    maintainers = with maintainers; [ wegank ];
  };
}
