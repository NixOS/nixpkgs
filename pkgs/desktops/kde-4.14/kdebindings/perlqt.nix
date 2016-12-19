{ kde, cmake, smokeqt, perl }:

kde {

  # TODO: qscintilla2, qwt5

  buildInputs = [ smokeqt perl ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Perl bindings for Qt library";
  };
}
