{ kde, cmake, smokeqt, perl }:

kde {
#todo: qscintilla2, qwt5
  buildInputs = [ smokeqt perl ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Perl bindings for Qt library";
  };
}
