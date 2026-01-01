{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "rendercv-fonts";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "rendercv";
    repo = "rendercv-fonts";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rwMiDoa/93FY3DFDxzR3sPyB8tCJzOnNbMZq8mBcx7M=";
=======
    hash = "sha256-fQ9iNN3hRCrhut+1F6q3dJEWoKUQyPol0/SyTPUPK1c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  # pythonRelaxDeps seems not taking effect for the build-system dependencies
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'hatchling==1.26.3' 'hatchling' \
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rendercv_fonts" ];

  meta = {
    description = "Python package with some fonts for the rendercv package";
    homepage = "https://github.com/rendercv/rendercv-fonts";
    changelog = "https://github.com/rendercv/rendercv-fonts/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
  };
}
