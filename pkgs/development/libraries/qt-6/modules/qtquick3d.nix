{
  qtModule,
  qtbase,
  qtdeclarative,
  openssl,
  fetchpatch,
}:

qtModule {
  pname = "qtquick3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [ openssl ];
  patches = [
    # should be able to remove on next update
    (fetchpatch {
      name = "fix-clang-19-build.patch";
      url = "https://github.com/qt/qtquick3d/commit/636a5558470ba0e0a4db1ca23dc72d96dfabeccf.patch";
      hash = "sha256-xBzOoVWDWvpxbSHKWeeWY1ZVldsjoUeJqFcfpvjEWAg=";
    })
  ];
}
