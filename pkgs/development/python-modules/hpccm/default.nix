{ lib
, fetchFromGitHub
, buildPythonPackage
, six
, archspec
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "hpccm";
  version = "22.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "hpc-container-maker";
    rev = "v${version}";
    hash = "sha256-dLMbwtvn7HTVVlWHAzXU19ERdJxytf9NlnqMXW6ShKI=";
  };

  propagatedBuildInputs = [ six archspec ];
  nativeCheckInputs = [ pytestCheckHook pytest-xdist ];

  disabledTests = [
    # tests require git
    "test_commit"
    "test_tag"
  ];

  pythonImportsCheck = [ "hpccm" ];

  meta = with lib; {
    description = "HPC Container Maker";
    homepage = "https://github.com/NVIDIA/hpc-container-maker";
    license = licenses.asl20;
    platforms = platforms.x86;
    maintainers = with maintainers; [ atila ];
  };
}
