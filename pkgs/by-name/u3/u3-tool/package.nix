{ lib, stdenv, fetchurl }:

stdenv.mkDerivation (finalAttrs: {
  pname = "u3-tool";
  version = "1.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "1p9c9kibd1pdbdfa0nd0i3n7bvzi3xg0chm38jg3xfl8gsn0390f";
  };


  meta = with lib; {
    description = "Tool for controlling the special features of a 'U3 smart drive' USB Flash disk";
    homepage = "https://sourceforge.net/projects/u3-tool/";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ makefu ];
    mainProgram = "u3-tool";
  };
})
