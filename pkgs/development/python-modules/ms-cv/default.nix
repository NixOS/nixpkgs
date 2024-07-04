{
  lib,
  buildPythonPackage,
  isPy27,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ms-cv";
  version = "0.1.1";
  format = "setuptools";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "OpenXbox";
    repo = "ms_cv";
    rev = "v${version}";
    sha256 = "0pkna0kvmq1cp4rx3dnzxsvvlxxngryp77k42wkyw2phv19a2mjd";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Correlation vector implementation in python";
    homepage = "https://github.com/OpenXbox/ms_cv";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
