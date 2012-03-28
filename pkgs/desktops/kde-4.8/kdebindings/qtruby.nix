{ kde, cmake, smokeqt, ruby }:

kde {
  buildInputs = [ smokeqt ruby ];
  buildNativeInputs = [ cmake ];

  # The second patch is not ready for upstream submmission. I should add an
  # option() instead.
  patches = [ ./qtruby-include-smokeqt.patch ./qtruby-install-prefix.patch ];

  cmakeFlags="-DRUBY_ROOT_DIR=${ruby}";

  meta = {
    description = "Ruby bindings for Qt library";
  };
}
