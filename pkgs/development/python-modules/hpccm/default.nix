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
  version = "22.5.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "hpc-container-maker";
    rev = "v${version}";
    sha256 = "sha256-zR5+X9BKaUvLPQ05FnfU817esgxVqP8n+wfdWy20BN4=";
  };

  propagatedBuildInputs = [ six archspec ];
  checkInputs = [ pytestCheckHook pytest-xdist ];

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
