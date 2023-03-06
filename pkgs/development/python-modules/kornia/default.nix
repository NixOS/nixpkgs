{ buildPythonPackage
, fetchFromGitHub
, lib

# propagated build inputs
, packaging
, pytorch

# check inputs
, pytestCheckHook
, opencv3
, scipy
}:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "kornia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4TE9GfcRMSpI18IEgAeuKjTroKGknc2dVlmXOdyiKuE";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  checkInputs = [
    pytestCheckHook
    opencv3
    scipy
  ];

  propagatedBuildInputs = [
    packaging
    pytorch
  ];

  # tests are extremely slow
  doCheck = false;

  pythonImportsCheck = ["kornia"];

  meta = with lib; {
    description = "Differentiable computer vision library for PyTorch";
    homepage = "https://kornia.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rehno-lindeque ];
  };
}
