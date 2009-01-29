{input, stdenv, fetchurl, pkgconfig, gtk, libxml2}:

assert pkgconfig != null && gtk != null && libxml2 != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [gtk libxml2];

  meta = {
    description = "Glade, a User Interface Designer for GTK+ and GNOME";

    longDescription = ''
      Glade is a RAD tool to enable quick & easy development of user
      interfaces for the GTK+ toolkit and the GNOME desktop
      environment, released under the GNU GPL License.

      The user interfaces designed in Glade are saved as XML, and by
      using the libglade library these can be loaded by applications
      dynamically as needed.

      By using libglade, Glade XML files can be used in numerous
      programming languages including C, C++, Java, Perl, Python, C#,
      Pike, Ruby, Haskell, Objective Caml and Scheme.  Adding support
      for other languages is easy too.
    '';

    license = "LGPLv2+";

    homepage = http://glade.gnome.org/;
  };
}
