{ stdenv, fetchurl, gnome_python, librsvg, libwnck, libgtop, pkgconfig, python2, gtk }:

let
  inherit (python2.pkgs) python pygtk;
in stdenv.mkDerivation rec {
  ver_maj = "2.32";
  ver_min = "0";
  version = "${ver_maj}.${ver_min}";
  name = "gnome-python-desktop-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-python-desktop/${ver_maj}/gnome-python-desktop-${version}.tar.bz2";
    sha256 = "1s8f9rns9v7qlwjv9qh9lr8crp88dpzfm45hj47zc3ivpy0dbnq9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk librsvg libwnck libgtop python ];
  propagatedBuildInputs = [ gnome_python pygtk ];

  # gnome-python-desktop expects that .pth file is already installed by PyGTK
  # in the same directory. This is not the case for Nix.
  postInstall = ''
    echo "gtk-2.0" > $out/${python2.sitePackages}/${name}.pth
  '';

  meta = with stdenv.lib; {
    homepage = http://www.pygtk.org;
    description = "Python bindings for GNOME desktop packages";
    license = licenses.lgpl21;
    maintainers = [ maintainers.goibhniu ];
  };
}
