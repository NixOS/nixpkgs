{
  stdenv,
  lib,
  fetchFromCodeberg,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tllist";
  version = "1.1.0";

  src = fetchFromCodeberg {
    owner = "dnkl";
    repo = "tllist";
    rev = finalAttrs.version;
    hash = "sha256-4WW0jGavdFO3LX9wtMPzz3Z1APCPgUQOktpmwAM0SQw=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonBuildType = "release";

  doCheck = true;

  meta = {
    homepage = "https://codeberg.org/dnkl/tllist";
    changelog = "https://codeberg.org/dnkl/tllist/releases/tag/${finalAttrs.version}";
    description = "C header file only implementation of a typed linked list";
    longDescription = ''
      Most C implementations of linked list are untyped. That is, their data
      carriers are typically void *. This is error prone since your compiler
      will not be able to help you correct your mistakes (oh, was it a
      pointer-to-a-pointer... I thought it was just a pointer...).

      tllist addresses this by using pre-processor macros to implement dynamic
      types, where the data carrier is typed to whatever you want; both
      primitive data types are supported as well as aggregated ones such as
      structs, enums and unions.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fionera ];
    platforms = lib.platforms.all;
  };
})
