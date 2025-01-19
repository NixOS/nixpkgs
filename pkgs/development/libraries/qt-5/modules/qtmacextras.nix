{
  lib,
  qtModule,
  qtbase,
}:

qtModule {
  pname = "qtmacextras";
  propagatedBuildInputs = [ qtbase ];
  meta = {
    maintainers = with lib.maintainers; [ periklis ];
    platforms = lib.platforms.darwin;
  };
}
