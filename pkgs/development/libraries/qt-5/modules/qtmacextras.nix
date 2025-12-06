{
  lib,
  qtModule,
  qtbase,
}:

qtModule {
  pname = "qtmacextras";
  propagatedBuildInputs = [ qtbase ];
  meta = {
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}
