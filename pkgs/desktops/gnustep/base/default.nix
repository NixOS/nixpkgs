{ lib
, stdenv
, aspell
, audiofile
, make
, wrapGNUstepAppsHook
, cups
, fetchzip
, fetchpatch
, gmp
, gnutls
, libffi
, binutils-unwrapped
, libjpeg
, libtiff
, libpng
, giflib
, libxml2
, libxslt
, libiconv
, libobjc
, libgcrypt
, icu
, pkg-config
, portaudio
, libiberty
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-base";
  version = "1.29.0";
  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-base-${finalAttrs.version}.tar.gz";
    hash = "sha256-4fjdsLBsYEDxLOFrq17dKii2sLKvOaFCu0cw3qQtM5U=";
  };
  outputs = [ "out" "dev" "lib" ];
  nativeBuildInputs = [ pkg-config make wrapGNUstepAppsHook ];
  propagatedBuildInputs = [
    aspell audiofile
    cups
    gmp gnutls
    libffi binutils-unwrapped
    libjpeg libtiff libpng giflib
    libxml2 libxslt libiconv
    libobjc libgcrypt
    icu
    portaudio
    libiberty
  ];
  patches = [
    ./fixup-paths.patch
    # https://github.com/gnustep/libs-base/issues/212 / https://www.sogo.nu/bugs/view.php?id=5416#c15585
    (fetchpatch {
      url = "https://github.com/gnustep/libs-base/commit/bd5f2909e6edc8012a0a6e44ea1402dfbe1353a4.patch";
      revert = true;
      sha256 = "02awigkbhqa60hfhqfh2wjsa960y3q6557qck1k2l231piz2xasa";
    })
    # https://github.com/gnustep/libs-base/issues/294
    (fetchpatch {
      url = "https://github.com/gnustep/libs-base/commit/37913d006d96a6bdcb963f4ca4889888dcce6094.patch";
      sha256 = "PyOmzRIirSKG5SQY+UwD6moCidPb8PXCx3aFgfwxsXE=";
    })
    # https://github.com/gnustep/libs-base/pull/334
    (fetchpatch {
      url = "https://github.com/gnustep/libs-base/commit/b4feee311f2beaf499a5742967213f523de30f16.patch";
      excludes = [ "ChangeLog" ];
      hash = "sha256-r0qpxjpEM6y+F/gju6JhpDNxnFJNHFG/mt3NmC1hWrs=";
    })
  ];

  meta = {
    changelog = "https://github.com/gnustep/libs-base/releases/tag/base-${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    description = "Implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = lib.platforms.linux;
  };
})
