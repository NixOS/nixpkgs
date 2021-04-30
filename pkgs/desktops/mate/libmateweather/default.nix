{ lib, stdenv, fetchurl, pkg-config, gettext, gtk3, libsoup, tzdata, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "libmateweather";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "02d7c59pami1fzxg73mp6risa9hvsdpgs68f62wkg09nrppzsk4v";
  };

  nativeBuildInputs = [ pkg-config gettext ];

  buildInputs = [ gtk3 libsoup tzdata ];

  configureFlags = [
    "--with-zoneinfo-dir=${tzdata}/share/zoneinfo"
    "--enable-locations-compression"
  ];

  preFixup = "rm -f $out/share/icons/mate/icon-theme.cache";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Library to access weather information from online services for MATE";
    homepage = "https://github.com/mate-desktop/libmateweather";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
