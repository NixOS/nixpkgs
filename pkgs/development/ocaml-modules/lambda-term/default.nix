{ stdenv, fetchurl, libev, buildDunePackage, zed, lwt_log, lwt_react }:

buildDunePackage rec {
  pname = "lambda-term";
  version = "1.13";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/diml/${pname}/archive/${version}.tar.gz";
    sha256 = "1hy5ryagqclgdm9lzh1qil5mrynlypv7mn6qm858hdcnmz9zzn0l";
  };

  buildInputs = [ libev ];
  propagatedBuildInputs = [ zed lwt_log lwt_react ];

  hasSharedObjects = true;

  meta = { description = "Terminal manipulation library for OCaml";
    longDescription = ''
    Lambda-term is a cross-platform library for
    manipulating the terminal. It provides an abstraction for keys,
    mouse events, colors, as well as a set of widgets to write
    curses-like applications.

    The main objective of lambda-term is to provide a higher level
    functional interface to terminal manipulation than, for example,
    ncurses, by providing a native OCaml interface instead of bindings to
    a C library.

    Lambda-term integrates with zed to provide text edition facilities in
    console applications.
    '';

    homepage = https://github.com/diml/lambda-term;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
