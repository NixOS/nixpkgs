{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtkmm3,
  glibmm,
  gtksourceview3,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gtksourceviewmm";
  version = "3.21.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceviewmm/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1danc9mp5mnb65j01qxkwj92z8jf1gns41wbgp17qh7050f0pc6v";
  };

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gtksourceviewmm";
      versionPolicy = "none";
      freeze = true;
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glibmm
    gtkmm3
    gtksourceview3
  ];

<<<<<<< HEAD
  meta = {
    platforms = lib.platforms.unix;
    homepage = "https://gitlab.gnome.org/GNOME/gtksourceviewmm";
    description = "C++ wrapper for gtksourceview";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.juliendehos ];
=======
  meta = with lib; {
    platforms = platforms.unix;
    homepage = "https://gitlab.gnome.org/GNOME/gtksourceviewmm";
    description = "C++ wrapper for gtksourceview";
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
