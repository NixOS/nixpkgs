{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "nvidia-texture-tools-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "castano";
    repo = "nvidia-texture-tools";
    rev = version;
    sha256 = "0p8ja0k323nkgm07z0qlslg6743vimy9rf3wad2968az0vwzjjyx";
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
    platforms = platforms.linux;
  };
}
