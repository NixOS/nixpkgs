{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
, pytest-cov
, dill
, numpy
, pytorch
, threadpoolctl
, tqdm
}:

buildPythonPackage rec {
  pname = "rising";
  version = "0.2.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "PhoenixDL";
    repo = pname;
    rev = "v${version}";
    sha256 = "15wYWToXRae1cMpHWbJwzAp0THx6ED9ixQgL+n1v9PI=";
  };

  propagatedBuildInputs = [ numpy pytorch threadpoolctl tqdm ];
  checkInputs = [ dill pytest-cov pytestCheckHook ];

  disabledTests = [ "test_affine" ];  # deprecated division operator '/'

  meta = {
    description = "High-performance data loading and augmentation library in PyTorch";
    homepage = "https://rising.rtfd.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
