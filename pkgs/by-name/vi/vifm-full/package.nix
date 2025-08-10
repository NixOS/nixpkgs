{
  vifm,
  lib,
  udisks2,
  python3,
}:

vifm.override {
  mediaSupport = true;
  inherit lib udisks2 python3;
}
