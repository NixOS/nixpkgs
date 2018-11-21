{ stdenv, fetchurl, meson, ninja, gettext, appstream-glib, gnome3 }:

let
  pname = "cantarell-fonts";
  version = "0.110";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "19rll0h4xjn83lqm0zc4088y0vkrx1wxg8jz9imvgd8snmfxfm54";
  };

  nativeBuildInputs = [ meson ninja gettext appstream-glib ];

  # ad-hoc fix for https://github.com/NixOS/nixpkgs/issues/50855
  # until we fix gettext's envHook
  preBuild = ''
    export GETTEXTDATADIRS="$GETTEXTDATADIRS_FOR_BUILD"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "052nxmhw2j8yvcj90r8xhjf0mzim8h6syip7winxb28vavj6jnba";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "Default typeface used in the user interface of GNOME since version 3.0";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.ofl;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
