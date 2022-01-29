{ qtModule
, qtbase
, qtdeclarative
, libiconv
  # FIXME Configure summary: qt5compat is not using libiconv. bug in qt6?
, icu
, openssl
}:

qtModule {
  pname = "qt5compat";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ libiconv icu openssl openssl.dev ];

  cmakeFlags = [
    "-DQT_FEATURE_iconv=ON" # icu?
    /*
    "-DQT_FEATURE_big_codecs=ON"
    "-DQT_FEATURE_codecs=ON" # icu?
    "-DQT_FEATURE_textcodec=ON" # icu?
    */
  ];
}
