{ kde, cmake, smokeqt, ruby }:

kde {

 # TODO: scintilla2, qwt5

  buildInputs = [ smokeqt ruby ];

  nativeBuildInputs = [ cmake ];

  # The patch is not ready for upstream submmission.
  # I should add an option() instead.
  patches = [ ./qtruby-install-prefix.patch ];

  cmakeFlags="-DRUBY_ROOT_DIR=${ruby}";

  meta = {
    description = "Ruby bindings for Qt library";
  };
}
