{ stdenv, lib, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mp4v2";
  version = "4.1.3";

  src = fetchFromGitHub {
    # 2020-06-20: THE current upstream, maintained and used in distros fork.
    owner = "TechSmith";
    repo = "mp4v2";
    rev = "Release-ThirdParty-MP4v2-${version}";
    sha256 = "053a0lgy819sbz92cfkq0vmkn2ky39bva554pj4ypky1j6vs04fv";
  };

  patches = [
    (fetchurl {
      # 2020-06-19: NOTE: # Fix build with C++11
      # Close when https://github.com/TechSmith/mp4v2/pull/36 merged/closed.
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/libmp4v2-c++11.patch?id=203f5a72bc97ffe089b424c47b07dd9eaea35713";
      sha256 = "0sbn0il7lmk77yrjyb4f0a3z3h8gsmdkscvz5n9hmrrrhrwf672w";
    })
  ];

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
