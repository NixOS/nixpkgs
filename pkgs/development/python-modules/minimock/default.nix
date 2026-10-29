{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "minimock";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lowks";
    repo = "minimock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ut3iKc7Sr28uGgWCV3K3CS+gBta2icvbUPMjjo4fflU=";
  };

  postPatch = ''
    substituteInPlace minimock.py \
      --replace-fail "__version__ = '1.2.10.dev0'" "__version__ = '${finalAttrs.version}'"
  '';

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
})
