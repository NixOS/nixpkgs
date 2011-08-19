{ kde, cmake, smokeqt, perl }:

kde {
  buildInputs = [ smokeqt perl ];
  buildNativeInputs = [ cmake ];

  meta = {
    description = "Perl bindings for Qt library";
  };
}
