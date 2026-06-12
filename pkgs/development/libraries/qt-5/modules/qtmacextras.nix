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
    hasNoMaintainersButDependents = true;
    platforms = lib.platforms.darwin;
  };
}
