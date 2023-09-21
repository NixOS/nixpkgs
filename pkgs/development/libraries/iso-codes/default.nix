{ lib, stdenv, fetchurl, gettext, python3 }:

stdenv.mkDerivation rec {
  pname = "iso-codes";
  version = "4.15.0";

  src = fetchurl {
    url = "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v${version}/${pname}-v${version}.tar.gz";
    sha256 = "sha256-uDtUudfdbrh3OAs+xG83CwXa8sv6ExxhLwNZjWVMDvg=";
  };

  nativeBuildInputs = [ gettext python3 ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://salsa.debian.org/iso-codes-team/iso-codes";
    description = "Various ISO codes packaged as XML files";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
