{ stdenv, lib, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mp4v2";
  version = "5.0.1";

  src = fetchFromGitHub {
    # 2020-06-20: THE current upstream, maintained and used in distros fork.
    owner = "TechSmith";
    repo = "mp4v2";
    rev = "Release-ThirdParty-MP4v2-${version}";
    sha256 = "sha256-OP+oVTH9pqYfHtYL1Kjrs1qey/J40ijLi5Gu8GJnvSY=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=narrowing";

  # `faac' expects `mp4.h'.
  postInstall = "ln -s mp4v2/mp4v2.h $out/include/mp4.h";

  enableParallelBuilding = true;

  meta = {
    description = "Provides functions to read, create, and modify mp4 files";
    longDescription = ''
      MP4v2 library provides an API to work with mp4 files
      as defined by ISO-IEC:14496-1:2001 MPEG-4 Systems.
      This container format is derived from Apple's QuickTime format.
    '';
    homepage = "https://github.com/TechSmith/mp4v2";
    maintainers = [ lib.maintainers.Anton-Latukha ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mpl11;
  };
}
