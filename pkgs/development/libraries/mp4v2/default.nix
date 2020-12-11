{ stdenv, lib, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mp4v2";
  version = "4.1.5";

  src = fetchFromGitHub {
    # 2020-06-20: THE current upstream, maintained and used in distros fork.
    owner = "TechSmith";
    repo = "mp4v2";
    rev = "Release-ThirdParty-MP4v2-${version}";
    sha256 = "0i8fy7gdqcwwla6fw50rr159jjlx01b1g13x3325a128wh33ghbg";
  };

  patches = [
    (fetchurl {
      # 2020-06-19: NOTE: # Fix build with C++11
      # Close when https://github.com/TechSmith/mp4v2/pull/36 merged/closed.
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/libmp4v2-c++11.patch?id=203f5a72bc97ffe089b424c47b07dd9eaea35713";
      sha256 = "0sbn0il7lmk77yrjyb4f0a3z3h8gsmdkscvz5n9hmrrrhrwf672w";
    })
  ] ++ stdenv.lib.optionals stdenv.cc.isClang [ ./fix-build-clang.patch ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  # `faac' expects `mp4.h'.
  postInstall = ''
    ln -s $dev/include/mp4v2/mp4v2.h $dev/include/mp4v2/mp4.h
  '';

  outputs = [ "out" "dev" "lib" ];

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
