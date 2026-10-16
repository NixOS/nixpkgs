{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ms-cv";
  version = "0.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OpenXbox";
    repo = "ms_cv";
    rev = "v${version}";
    hash = "sha256-TVahUtjwCu4nF2Sec31+tne6t+7fttEzuSzguidQdl4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Correlation vector implementation in python";
    homepage = "https://github.com/OpenXbox/ms_cv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
