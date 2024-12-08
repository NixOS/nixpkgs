{ lib
, stdenv
, make
, wrapGNUstepAppsHook
, fetchzip
, base
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.31.1";
  pname = "gnustep-gui";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-+4XEJ6PKpantbIbyNroFMaNBTFffkuW/ajSocGQO9Mo=";
  };

  nativeBuildInputs = [ make wrapGNUstepAppsHook ];
  buildInputs = [ base ];

  patches = [
    ./fixup-all.patch
  ];
  meta = {
    changelog = "https://github.com/gnustep/libs-gui/releases/tag/gui-${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    description = "GUI class library of GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = lib.platforms.linux;
  };
})
