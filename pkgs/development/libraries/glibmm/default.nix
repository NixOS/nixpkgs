{ stdenv, fetchurl, fetchpatch, pkgconfig, gnum4, glib, libsigcxx }:

let
  ver_maj = "2.56";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "glibmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${ver_maj}/${name}.tar.xz";
    sha256 = "1abrkqhca5p8n6ly3vp1232rny03s7lrd8f8iz2m2m141nxgqx3f";
  };

  outputs = [ "out" "dev" ];

  patchFlags = "-p0";
  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/e864b2340be9ef003d8ff4aef92e7151d06287dd/devel/glibmm/files/0001-ustring-Fix-wchar-conversion-on-macOS-with-libc.patch";
      sha256 = "02qvnailw1i59cjbj3cy7y02kfcivsvkdjrf4njkp4plarayyqp9";
    })
  ];

  nativeBuildInputs = [ pkgconfig gnum4 ];
  propagatedBuildInputs = [ glib libsigcxx ];

  enableParallelBuilding = true;

  doCheck = false; # fails. one test needs the net, another /etc/fstab

  meta = with stdenv.lib; {
    description = "C++ interface to the GLib library";

    homepage = https://gtkmm.org/;

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [raskin];
    platforms = platforms.unix;
  };
}
