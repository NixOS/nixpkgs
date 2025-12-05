{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
}:

buildPythonPackage {
  pname = "ovmfvartool";
  version = "unstable-2022-09-04";
  format = "setuptools";

  src = fetchFromGitHub {
    # https://github.com/hlandau/ovmfvartool/pull/4
    owner = "baloo";
    repo = "ovmfvartool";
    rev = "6a17190131bf44699ea27815543a65efff880142";
    hash = "sha256-lIneg3kL21oxqjsraogGlOVsgmYnp38CPav1TwBg0p0=";
  };

  propagatedBuildInputs = [ pyyaml ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "ovmfvartool" ];

  meta = with lib; {
    description = "Parse and generate OVMF_VARS.fd from Yaml";
    mainProgram = "ovmfvartool";
    homepage = "https://github.com/hlandau/ovmfvartool";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      baloo
      raitobezarius
    ];
  };
}
