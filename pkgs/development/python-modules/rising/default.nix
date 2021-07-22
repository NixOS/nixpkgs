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
  version = "0.2.0post0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "PhoenixDL";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fb9894ppcp18wc2dhhjizj8ja53gbv9wpql4mixxxdz8z2bn33c";
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
