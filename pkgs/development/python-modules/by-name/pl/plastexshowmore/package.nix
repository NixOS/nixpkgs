{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  plasTeX,
}:

buildPythonPackage {
  pname = "plastexshowmore";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "plastexshowmore";
    owner = "PatrickMassot";
    rev = "0.0.2";
    hash = "sha256-b45VHHEwFA41FaInDteix56O7KYDzyKiRRSl7heHqEA=";
  };

  build-system = [ setuptools ];

  dependencies = [ plasTeX ];

  meta = {
    description = "PlasTeX plugin for adding navigation buttons";
    homepage = "https://github.com/PatrickMassot/plastexshowmore";
    maintainers = with lib.maintainers; [ niklashh ];
    license = lib.licenses.asl20;
  };
}
