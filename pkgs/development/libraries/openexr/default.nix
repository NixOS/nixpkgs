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

let
  non_glibc_fpstate_patch =
    # Fix ilmbase/openexr using glibc-only fpstate.
    # Found via https://git.alpinelinux.org/aports/tree/community/openexr/10-musl-_fpstate.patch?id=80d9611b7b8e406a554c6f511137e03ff26acbae,
    # TODO Remove when https://github.com/AcademySoftwareFoundation/openexr/pull/798 is merged and available.
    #      Remove it from `ilmbase` as well then.
    (fetchpatch {
      name = "ilmbase-musl-_fpstate.patch.patch";
      url = "https://raw.githubusercontent.com/void-linux/void-packages/80bbc168faa25448bd3399f4df331b836e74b85c/srcpkgs/ilmbase/patches/musl-_fpstate.patch";
      sha256 = "0appzbs9pd6dia5pzxmrs9ww35shlxi329ks6lchwzw4f2a81arz";
    });
in

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "020gyl8zv83ag6gbcchmqiyx9rh2jca7j8n52zx1gk4rck7kwc01";
  };

  outputs = [ "bin" "dev" "out" "doc" ];
  nativeBuildInputs = [ cmake libtool ];
  propagatedBuildInputs = [ ilmbase zlib ];

  postPatch =
    if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.libc != "glibc")
      then
        ''
          patch -p0 < ${non_glibc_fpstate_patch}
        ''
      else null; # `null` avoids rebuild on glibc

  enableParallelBuilding = true;

  passthru = {
    # So that ilmbase (sharing the same source code) can re-use this patch.
    inherit non_glibc_fpstate_patch;
  };

  meta = with stdenv.lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
