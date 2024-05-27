{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "minimock";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lowks";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ut3iKc7Sr28uGgWCV3K3CS+gBta2icvbUPMjjo4fflU=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "minimock" ];

  meta = with lib; {
    description = "A minimalistic mocking library";
    homepage = "https://pypi.python.org/pypi/MiniMock";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
