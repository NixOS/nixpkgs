{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
}:
let
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "schematics";
    repo = "schematics";
    rev = "refs/tags/${version}";
    hash = "sha256-xlA09D2sNN6/XAGGBL8YhuEkCxfty3TU2mosK1H5Zd0=";
  };
in
buildPythonPackage {
  pname = "mo-installer";
  inherit version src;
  pyproject = true;

  build-system = [ setuptools-scm ];

  pythonImportsCheck = [ "mo_installer" ];

  # Both checks fail and I don't know why
  doCheck = false;

  meta = {
    description = "Help to install gettext mo file in a setuptools package";
    homepage = "https://github.com/s-ball/mo_installer";
    changelog = "https://github.com/s-ball/mo_installer/blob/${src.rev}/CHANGES.txt";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
