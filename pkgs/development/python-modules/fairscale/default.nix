{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  # build inputs
  torch,
  numpy,
  ninja,
  # check inputs
  pytestCheckHook,
  parameterized,
  pytest-cov,
  pytest-timeout,
  remote-pdb,
}:
let
  pname = "fairscale";
  version = "0.4.13";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fairscale";
    rev = "refs/tags/v${version}";
    hash = "sha256-L2Rl/qL6l0OLAofygzJBGQdp/2ZrgDFarwZRjyAR3dw=";
  };

  # setup.py depends on ninja python dependency, but we have the binary in nixpkgs
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'setup_requires=["ninja"]' 'setup_requires=[]'
  '';

  nativeBuildInputs = [
    ninja
    setuptools
  ];

  propagatedBuildInputs = [
    torch
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    parameterized
    pytest-cov
    pytest-timeout
    remote-pdb
  ];

  # Some tests try to build distributed models, which doesn't work in the sandbox.
  doCheck = false;

  pythonImportsCheck = [ "fairscale" ];

  meta = with lib; {
    description = "PyTorch extensions for high performance and large scale training";
    mainProgram = "wgit";
    homepage = "https://github.com/facebookresearch/fairscale";
    changelog = "https://github.com/facebookresearch/fairscale/releases/tag/v${version}";
    license = with licenses; [
      mit
      asl20
      bsd3
    ];
    maintainers = with maintainers; [ happysalada ];
  };
}
