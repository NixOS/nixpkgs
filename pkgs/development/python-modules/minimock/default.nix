{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "minimock";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lowks";
    repo = "minimock";
    rev = "v${version}";
    hash = "sha256-Ut3iKc7Sr28uGgWCV3K3CS+gBta2icvbUPMjjo4fflU=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "minimock" ];

  meta = {
    description = "Minimalistic mocking library";
    homepage = "https://pypi.org/project/MiniMock/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
