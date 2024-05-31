{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build
  pytest,

  # tests
  pytestCheckHook,
}:

let
  pname = "pytest-describe";
  version = "2.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ObsF65DySX2co0Lvmgt/pbraflhQWuwz9m1mHWMZVbc=";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Describe-style plugin for the pytest framework";
    homepage = "https://github.com/pytest-dev/pytest-describe";
    changelog = "https://github.com/pytest-dev/pytest-describe/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
