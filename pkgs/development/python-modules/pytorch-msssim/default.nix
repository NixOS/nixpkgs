{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  torch,
}:

buildPythonPackage rec {
  pname = "pytorch-msssim";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VainF";
    repo = "pytorch-msssim";
    rev = "refs/tags/v${version}";
    hash = "sha256-bghglwQhgByC7BqbDvImSvt6edKF55NLYEPjqmmSFH8=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ torch ];

  pythonImportsCheck = [ "pytorch_msssim" ];

  # This test doesn't have (automatic) tests
  doCheck = false;

  meta = with lib; {
    description = "Fast and differentiable MS-SSIM and SSIM for pytorch";
    homepage = "https://github.com/VainF/pytorch-msssim";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
