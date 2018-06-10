{ stdenv, fetchurl, meson, ninja, gettext, appstream-glib, gnome3 }:

let
  pname = "cantarell-fonts";
  version = "0.100";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1286rx1z7mrmi6snx957fprpcmd5p00l6drdfpbgf6mqapl6kb81";
  };

  nativeBuildInputs = [ meson ninja gettext appstream-glib ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "12ia41pr0rzjfay6y84asw3nxhyp1scq9zl0w4f6wkqj7vf1qfn1";

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
