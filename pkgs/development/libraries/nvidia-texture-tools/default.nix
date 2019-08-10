{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "nvidia-texture-tools-${version}";
  version = "unstable-2019-08-10";

  src = fetchFromGitHub {
    owner = "castano";
    repo = "nvidia-texture-tools";
    rev = "662d223626185f7c6c7e0d822a4796a691acc05a";
    sha256 = "0s598qzcfnbw18vp4rha96hpar7j9mml7w6swzmvkk8pdlgrwsn5";
  };

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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A set of cuda-enabled texture tools and compressors";
    homepage = https://github.com/castano/nvidia-texture-tools;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
