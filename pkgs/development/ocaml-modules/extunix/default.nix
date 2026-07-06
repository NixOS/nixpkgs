{
  lib,
  buildDunePackage,
  fetchurl,
  dune-configurator,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "extunix";
  version = "0.4.4";

  minimalOCamlVersion = "5.3.0";

  src = fetchurl {
    url = "https://github.com/ygrek/extunix/releases/download/v${finalAttrs.version}/extunix-${finalAttrs.version}.tbz";
    hash = "sha256-kzTIkjFiI+aK73lcpystQp1O7Apkf0GLA142oFPRSX0=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace-fail 'libraries unix bigarray bytes' 'libraries unix bigarray'
  '';

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    ppxlib
  ];

  # need absolute paths outside from sandbox
  doCheck = false;

  meta = {
    description = "Collection of thin bindings to various low-level system API";
    homepage = "https://github.com/ygrek/extunix";
    changelog = "https://github.com/ygrek/extunix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
