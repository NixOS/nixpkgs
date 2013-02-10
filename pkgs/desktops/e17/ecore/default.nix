{ stdenv, fetchurl, pkgconfig, eina, evas, libX11, libXext, libXrender
, libXcomposite, libXfixes, libXdamage }:
stdenv.mkDerivation rec {
  name = "ecore-${version}";
  version = "1.7.5";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "08ljda6p0zj1h5sq3l0js6mihw8cr6ydynn42dnka36vachvmfjb";
  };
  buildInputs = [ pkgconfig eina evas ];
  propagatedBuildInputs = [ libX11 libXext libXcomposite libXrender libXfixes
                            libXdamage
                          ];
  meta = {
    description = "Enlightenment's core mainloop, display abstraction and utility library";
    longDescription = ''
      Enlightenment's Ecore is a clean and tiny event loop library
      with many modules to do lots of convenient things for a
      programmer, to save time and effort.

      It's small and lean, designed to work on embedded systems all
      the way to large and powerful multi-cpu workstations. It
      serialises all system signals, events etc. into a single event
      queue, that is easily processed without needing to worry about
      concurrency. A properly written, event-driven program using this
      kind of programming doesn't need threads, nor has to worry about
      concurrency. It turns a program into a state machine, and makes
      it very robust and easy to follow.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
