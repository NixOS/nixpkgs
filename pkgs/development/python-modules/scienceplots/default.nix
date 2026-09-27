{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "SciencePlots";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garrettj403";
    repo = "SciencePlots";
    rev = version;
    sha256 = "sha256-Sj0SdTu0M0wgTiUuC9ad73W8olsnbjzJgkaIsYKPYvo=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ matplotlib ];

  pythonImportsCheck = [ "scienceplots" ];

  doCheck = false; # no tests

  meta = {
    description = "Matplotlib styles for scientific plotting";
    homepage = "https://github.com/garrettj403/SciencePlots";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilimnik ];
  };
}
