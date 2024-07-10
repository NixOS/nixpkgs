{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "expandvars";
  version = "0.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fRrfpVcoz0tdgS7OPQh3A/rqlT4MChp4QV3p31Ak2EQ=";
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
