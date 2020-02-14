{ stdenv, fetchurl, python, buildPythonPackage, pkgconfig, glib, isPy3k }:

buildPythonPackage rec {
  pname = "pygobject";
  version = "2.28.7";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/2.28/${pname}-${version}.tar.xz";
    sha256 = "0nkam61rsn7y3wik3vw46wk5q2cjfh2iph57hl9m39rc8jijb7dv";
  };

  outputs = [ "out" "devdoc" ];

  patches = stdenv.lib.optionals stdenv.isDarwin [
    ./pygobject-2.0-fix-darwin.patch
  ];

  configureFlags = [ "--disable-introspection" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib ];

  # in a "normal" setup, pygobject and pygtk are installed into the
  # same site-packages: we need a pth file for both. pygtk.py would be
  # used to select a specific version, in our setup it should have no
  # effect, but we leave it in case somebody expects and calls it.
  postInstall = stdenv.lib.optionalString (!isPy3k) ''
    mv $out/lib/${python.libPrefix}/site-packages/{pygtk.pth,${pname}-${version}.pth}

    # Prevent wrapping of codegen files as these are meant to be
    # executed by the python program
    chmod a-x $out/share/pygobject/*/codegen/*.py
  '';

  meta = {
    homepage = "https://pygobject.readthedocs.io/";
    description = "Python bindings for GLib";
    platforms = stdenv.lib.platforms.unix;
  };
}
