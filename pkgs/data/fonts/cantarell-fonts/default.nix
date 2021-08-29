{ lib, stdenv, fetchurl, meson, ninja, gettext, appstream-glib, gnome }:

stdenv.mkDerivation rec {
  pname = "cantarell-fonts";
  version = "0.301";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "3d35db0ac03f9e6b0d5a53577591b714238985f4cfc31a0aa17f26cd74675e83";
  };

  nativeBuildInputs = [ meson ninja gettext appstream-glib ];

  # ad-hoc fix for https://github.com/NixOS/nixpkgs/issues/50855
  # until we fix gettext's envHook
  preBuild = ''
    export GETTEXTDATADIRS="$GETTEXTDATADIRS_FOR_BUILD"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1sczskw2kv3qy39i9mzw2lkl94a90bjgv5ln9acy5kh4gb2zmy7z";

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
