{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "0install-solver";
  version = "2.18";

  src = fetchFromGitHub {
    owner = "0install";
    repo = "0install";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CxADWMYZBPobs65jeyMQjqu3zmm2PgtNgI/jUsYUp8I=";
  };

  doCheck = true;
  checkInputs = [
    ounit2
  ];

  meta = {
    description = "Package dependency solver";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.stepbrobd ];
    homepage = "https://0install.net";
  };
})
