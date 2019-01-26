{ stdenv, fetchurl, fetchpatch, intltool, pkgconfig, glib, gtk, ncurses
, pythonSupport ? false, python27Packages}:

let
  inherit (python27Packages) python pygtk;
in stdenv.mkDerivation rec {
  name = "vte-0.28.2";

  src = fetchurl {
    url = "mirror://gnome/sources/vte/0.28/${name}.tar.bz2";
    sha256 = "00zrip28issgmz2cqk5k824cbqpbixi5x7k88zxksdqpnq1f414d";
  };

  patches = [
    ./alt.patch
    ./change-scroll-region.patch
    # CVE-2012-2738
    # fixed in upstream version 0.32.2
    (fetchpatch{
      name = "CVE-2012-2738-1.patch";
      url = https://gitlab.gnome.org/GNOME/vte/commit/feeee4b5832b17641e505b7083e0d299fdae318e.patch;
      sha256 = "1455i6zxcx4rj2cz639s8qdc04z2nshprwl7k00mcsw49gv3hk5n";
    })
    (fetchpatch{
      name = "CVE-2012-2738-2.patch";
      url = https://gitlab.gnome.org/GNOME/vte/commit/98ce2f265f986fb88c38d508286bb5e3716b9e74.patch;
      sha256 = "0n24vw49h89w085ggq23iwlnnb6ajllfh2dg4vsar21d82jxc0sn";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib gtk ncurses ] ++
                stdenv.lib.optionals pythonSupport [python pygtk];

  configureFlags = [
    (stdenv.lib.enableFeature pythonSupport "python")
  ];

  postInstall = stdenv.lib.optionalString pythonSupport ''
    cd $(toPythonPath $out)/gtk-2.0
    for n in *; do
      ln -s "gtk-2.0/$n" "../$n"
    done
  '';

  meta = {
    homepage = https://www.gnome.org/;
    description = "A library implementing a terminal emulator widget for GTK+";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK+, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
    '';
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
