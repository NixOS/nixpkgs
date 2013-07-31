{ kde, cmake, smokeqt, ruby }:

kde {
#todo: scintilla2, qwt5
  buildInputs = [ smokeqt ruby ];
  nativeBuildInputs = [ cmake ];

  patches = [ ./qtruby-install-prefix.patch ];

  cmakeFlags="-DRUBY_ROOT_DIR=${ruby}";

  meta = {
    description = "Ruby bindings for Qt library";
  };
}
