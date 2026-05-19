{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wego";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "schachmat";
    repo = "wego";
    rev = finalAttrs.version;
    sha256 = "sha256-RKVVOgM6eEWTHYb++AVTTjPLm/4R9SHFly4boRw9Ktw=";
  };

  vendorHash = "sha256-PSl0bGzyG9XBZPi8+YzLNq3JEm7QtmfX0272xOgtbek=";

  meta = {
    homepage = "https://github.com/schachmat/wego";
    description = "Weather app for the terminal";
    license = lib.licenses.isc;
    mainProgram = "wego";
  };
})
