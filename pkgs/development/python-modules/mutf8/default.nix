{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mutf8";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

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

  meta = with lib; {
    description = "Fast MUTF-8 encoder & decoder";
    homepage = "https://github.com/TkTech/mutf8";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
