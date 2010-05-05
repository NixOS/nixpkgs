{ stdenv, fetchurl, kdevplatform, cmake, pkgconfig, automoc4, shared_mime_info,
  kdebase_workspace, gettext, perl }:

stdenv.mkDerivation rec {
  name = "kdevelop-4.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/4.0.0/src/${name}.tar.bz2";
    sha256 = "0cnwhfk71iksip17cjzf3g68n751k8fz2acin6qb27k7sh71pdfp";
  };

  buildInputs = [ kdevplatform cmake pkgconfig automoc4 shared_mime_info
    kdebase_workspace gettext stdenv.gcc.libc perl ];
}
