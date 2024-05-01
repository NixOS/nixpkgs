{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, gettext
, itstool
, libxml2
, gtk3
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
# can be defaulted to true once engrampa builds with meson (version > 1.27.0)
, withMagic ? stdenv.buildPlatform.canExecute stdenv.hostPlatform, file
}:

stdenv.mkDerivation rec {
  pname = "engrampa";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "8CJBB6ek6epjCcnniqX6rIAsTPcqSawoOqnnrh6KbEo=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/mate-desktop/engrampa/security/advisories/GHSA-c98h-v39w-3r7v
      name = "CVE-2023-52138.patch";
      url = "https://github.com/mate-desktop/engrampa/commit/63d5dfa9005c6b16d0f0ccd888cc859fca78f970.patch";
      hash = "sha256-0N5JifaT/uX3KJd11CDLxl/woBNVpFoaz8xYQsacH+8=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    libxml2  # for xmllint
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    mate.caja
    hicolor-icon-theme
    mate.mate-desktop
  ] ++ lib.optionals withMagic [
    file
  ];

  configureFlags = [
    "--with-cajadir=$$out/lib/caja/extensions-2.0"
  ] ++ lib.optionals withMagic [
    "--enable-magic"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Archive Manager for MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
