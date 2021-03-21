{ lib, stdenv, fetchurl, meson, ninja, gettext, appstream-glib, gnome3 }:

let
  pname = "cantarell-fonts";
  version = "0.301";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "10sycxscs9kzl451mhygyj2qj8qlny8pamskb86np7izq05dnd9x";
  };

  nativeBuildInputs = [ meson ninja gettext appstream-glib ];

  # ad-hoc fix for https://github.com/NixOS/nixpkgs/issues/50855
  # until we fix gettext's envHook
  preBuild = ''
    export GETTEXTDATADIRS="$GETTEXTDATADIRS_FOR_BUILD"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "12ps2gjv1lmzbmkv16vgjmaahl3ayadpniyrx0z31sqn443r57hq";

  passthru = {
    updateScript = gnome3.updateScript {
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
