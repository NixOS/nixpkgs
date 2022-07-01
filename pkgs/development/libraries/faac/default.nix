{ lib, stdenv, fetchurl, autoreconfHook
, mp4v2Support ? true, mp4v2 ? null
, drmSupport ? false # Digital Radio Mondiale
}:

assert mp4v2Support -> (mp4v2 != null);

with lib;
stdenv.mkDerivation rec {
  pname = "faac";
  version = "1.30";

  src = fetchurl {
    url = "mirror://sourceforge/faac/${pname}-${builtins.replaceStrings ["."] ["_"] version}.tar.gz";
    sha256 = "1lmj0dib3mjp84jhxc5ddvydkzzhb0gfrdh3ikcidjlcb378ghxd";
  };

  configureFlags = [ ]
    ++ optional mp4v2Support "--with-external-mp4v2"
    ++ optional drmSupport "--enable-drm";

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ ]
    ++ optional mp4v2Support mp4v2;

  enableParallelBuilding = true;

  meta = {
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    license     = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
