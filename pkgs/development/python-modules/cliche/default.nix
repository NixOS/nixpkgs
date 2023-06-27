{ lib
, buildPythonPackage
, fetchFromGitHub
, ipdb
, pytestCheckHook
}:

buildPythonPackage {
  pname = "cliche";
  version = "0.10.108";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kootenpv";
    repo = "cliche";
    rev = "80a9ae2e90f4493880b669d5db51f1d4038589df"; # no tags
    sha256 = "sha256-7/icSneLQzwdkRL/mS4RjsgnKa6YIVvGCmdS6pB6r5Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ipdb == 0.13.9" "ipdb"
  '';

  propagatedBuildInputs = [ ipdb ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cliche" ];

  meta = with lib; {
    description = "Build a simple command-line interface from your functions :computer:";
    homepage = "https://github.com/kootenpv/cliche";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
