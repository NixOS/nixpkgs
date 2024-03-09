{ stdenv
, lib
, fetchurl
, meson
, ninja
, python3
, gettext
, appstream-glib
, gnome
}:

stdenv.mkDerivation rec {
  pname = "cantarell-fonts";
  version = "0.303.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "+UY6BlnGPlfjgf3XU88ZKSJTlcW0kTWYlCR2GDBTBBE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    python3.pkgs.psautohint
    python3.pkgs.cffsubr
    python3.pkgs.statmake
    python3.pkgs.ufo2ft
    python3.pkgs.setuptools
    python3.pkgs.ufolib2
    gettext
    appstream-glib
  ];

  # ad-hoc fix for https://github.com/NixOS/nixpkgs/issues/50855
  # until we fix gettext's envHook
  preBuild = ''
    export GETTEXTDATADIRS="$GETTEXTDATADIRS_FOR_BUILD"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "XeqHVdTQ7PTzxkjwfzS/BTR7+k/M69sfUKdRXGOTmZE=";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "Default typeface used in the user interface of GNOME since version 3.0";
    platforms = lib.platforms.all;
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ];
  };
}
