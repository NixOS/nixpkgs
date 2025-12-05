{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  zed,
  lwt_log,
  lwt_react,
  mew_vi,
  uucp,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "lambda-term";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "lambda-term";
    tag = finalAttrs.version;
    hash = "sha256-T2DDpHqLar1sgmju0PLvhAZef5VzOpPWcFVhuZlPQmM=";
  };

  propagatedBuildInputs = [
    zed
    lwt_log
    lwt_react
    mew_vi
    uucp
    logs
  ];

  meta = {
    description = "Terminal manipulation library for OCaml";
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

    homepage = "https://github.com/ocaml-community/lambda-term";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.gal_bolle ];
    mainProgram = "lambda-term-actions";
  };
})
