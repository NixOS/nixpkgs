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
    owner = "hlandau";
    repo = "ovmfvartool";
    rev = "45e6b1e53967ee6590faae454c076febce096931";
    hash = "sha256-XbvcE/MXNj5S5N7A7jxdwgEE5yMuB82Xg+PYBsFRIm0=";
  };

  propagatedBuildInputs = [ pyyaml ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "ovmfvartool" ];

  meta = {
    description = "Parse and generate OVMF_VARS.fd from Yaml";
    mainProgram = "ovmfvartool";
    homepage = "https://github.com/hlandau/ovmfvartool";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      baloo
      raitobezarius
    ];
  };
}
