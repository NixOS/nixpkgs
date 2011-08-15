{ kde, cmake, kdebindings, perl }:

kde {
  buildInputs = [ kdebindings.smokeqt perl ];
  buildNativeInputs = [ cmake ];

  meta = {
    description = "Perl bindings for Qt library";
  };
}
