{ lib
, stdenv
, buildPackages
, fetchFromGitHub
, zlib
, ilmbase
, fetchpatch
, cmake
, libtool
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "2.5.2";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "dtVoXA3JdmNs1iqu7cZlAdxt/CAgL5lSbOwu0SheyO0=";
  };

  patches = [
    # Fix pkg-config paths
    (fetchpatch {
      url = "https://github.com/AcademySoftwareFoundation/openexr/commit/6442fb71a86c09fb0a8118b6dbd93bcec4883a3c.patch";
      sha256 = "bwD5WTKPT4DjOJDnPXIvT5hJJkH0b71Vo7qupWO9nPA=";
    })
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.libc != "glibc") [
    # Fix ilmbase/openexr using glibc-only fpstate.
    # Found via https://git.alpinelinux.org/aports/tree/community/openexr/10-musl-_fpstate.patch?id=80d9611b7b8e406a554c6f511137e03ff26acbae,
    # TODO Remove when https://github.com/AcademySoftwareFoundation/openexr/pull/798 is merged and available.
    (fetchpatch {
      name = "ilmbase-musl-_fpstate.patch.patch";
      url = "https://raw.githubusercontent.com/void-linux/void-packages/80bbc168faa25448bd3399f4df331b836e74b85c/srcpkgs/ilmbase/patches/musl-_fpstate.patch";
      sha256 = "1bmyg4qfbz2p5iflrakbj8jzs85s1cf4cpfyclycnnqqi45j8m8d";
      # The patch's files are written as `IlmBase/...`, this turns it into
      # `a/IlmBase/...`, so that the `patch -p1` that `patches` does works.
      extraPrefix = ""; # Changing this requires changing the `sha256` (fixed-output)!
    })
  ];
  nativeBuildInputs = [ cmake libtool ];
  propagatedBuildInputs = [ ilmbase zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
