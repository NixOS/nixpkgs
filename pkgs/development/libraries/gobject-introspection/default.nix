{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python, gdk_pixbuf }:

# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

stdenv.mkDerivation rec {
  name = "gobject-introspection-1.36.0";

  buildInputs = [ flex bison glib pkgconfig python
    # break cyclic dependency:
    (gdk_pixbuf.override { gobjectIntrospection = null; })
  ];

  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = "--disable-tests";


  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/1.36/${name}.tar.xz";
    sha256 = "10v3idh489vra7pjn1g8f844nnl6719zgkgq3dv38xcf8afnvrz3";
  };

  postInstall = "rm -rf $out/share/gtk-doc";

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    homepage = http://live.gnome.org/GObjectIntrospection;
  };
}
