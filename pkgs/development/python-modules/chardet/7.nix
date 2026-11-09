{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "chardet";
  version = "7.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chardet";
    repo = "chardet";
    tag = finalAttrs.version;
    hash = "sha256-7xloMYaoAB1uwj4/5KK8PFd/mjXTgMFjS0SGW7Rrynw=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    ln -s ${
      fetchFromGitHub {
        owner = "chardet";
        repo = "test-data";
        tag = finalAttrs.version;
        hash = "sha256-kgD/fCxVuxgn6x2JVf4ij8ptzRi7AfqswccQ0akWL0s=";
      }
    } tests/data
  '';

  pythonImportsCheck = [ "chardet" ];

  meta = {
    changelog = "https://github.com/chardet/chardet/releases/tag/${finalAttrs.src.tag}";
    description = "Universal encoding detector";
    mainProgram = "chardetect";
    homepage = "https://github.com/chardet/chardet";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
})
