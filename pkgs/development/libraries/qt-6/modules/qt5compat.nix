{
  qtModule,
  qtbase,
  qtdeclarative,
  libiconv,
  icu,
  openssl,
}:

qtModule {
  pname = "qt5compat";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [
    libiconv
    icu
    openssl
  ];
}
