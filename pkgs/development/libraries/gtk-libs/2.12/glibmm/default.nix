args: with args;

stdenv.mkDerivation {
  name = "glibmm-2.16.2";
  src = fetchurl {
    url = mirror://gnome/GNOME/sources/glibmm/2.16/glibmm-2.16.2.tar.bz2;
    sha256 = "0a3d4z3kzbr84pg873397nja6wc6810pw233rvn1gz1jkkrzcczh";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [glib libsigcxx];
}
