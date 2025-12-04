{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ounit2,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "extunix";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "ygrek";
    repo = "extunix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7wJDGv19etkDHRwwQ+WONtJswxNMjr2Q2Vhis4WgFek=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'libraries unix bigarray bytes' 'libraries unix bigarray'
  '';

  nativeBuildInputs = [
    dune-configurator
    ppxlib
  ];

  propagatedBuildInputs = [
    dune-configurator
    ppxlib
  ];

  meta = {
    description = "Collection of thin bindings to various low-level system API";
    homepage = "https://github.com/ygrek/extunix";
    changelog = "https://github.com/ygrek/extunix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
