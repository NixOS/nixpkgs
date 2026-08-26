{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
}:

buildPythonPackage rec {
  pname = "mutf8";
  version = "1.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "TkTech";
    repo = "mutf8";
    rev = "v${version}";
    hash = "sha256-4Ojn3t0EbOVdrYEiY8JegJuvW9sz8jt9tKFwOluiGQo=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    # Using pytestCheckHook results in test failures
    pytest
  '';

  pythonImportsCheck = [ "mutf8" ];

  meta = {
    description = "Fast MUTF-8 encoder & decoder";
    homepage = "https://github.com/TkTech/mutf8";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
