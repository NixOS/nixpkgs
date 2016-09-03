{ kde, cmake, smokeqt, ruby_2_2 }:

kde {

 # TODO: scintilla2, qwt5

  buildInputs = [ smokeqt ruby_2_2 ];

  nativeBuildInputs = [ cmake ];

  hardeningDisable = [ "all" ];

  # The patch is not ready for upstream submmission.
  # I should add an option() instead.
  patches = [ ./qtruby-install-prefix.patch ];

  cmakeFlags="-DRUBY_ROOT_DIR=${ruby_2_2}";

  meta = {
    description = "Ruby bindings for Qt library";
  };
}
