{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "expandvars";
  version = "1.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8EBwuCYCZBhfgRQs2F5d+c7vcinoNsWEQwLEzPoAww0=";
  };

  nativeBuildInputs = [ hatchling ];

  pythonImportsCheck = [ "expandvars" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Expand system variables Unix style";
    homepage = "https://github.com/sayanarijit/expandvars";
    license = licenses.mit;
    maintainers = with maintainers; [ geluk ];
  };
}
