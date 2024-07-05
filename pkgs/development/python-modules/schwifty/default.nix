{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  importlib-resources,
  iso3166,
  pycountry,

  # optional-dependencies
  pydantic,

  # tests
  pytestCheckHook,
  pytest-cov,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "schwifty";
  version = "2024.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1EV2oi2LBcjw2U7nKqdVUVDlFCzR8RqX5tVIciw1trg=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    iso3166
    pycountry
  ] ++ lib.optionals (pythonOlder "3.12") [ importlib-resources ];

  passthru.optional-dependencies = {
    pydantic = [ pydantic ];
  };

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "schwifty" ];

  meta = with lib; {
    changelog = "https://github.com/mdomke/schwifty/blob/${version}/CHANGELOG.rst";
    description = "Validate/generate IBANs and BICs";
    homepage = "https://github.com/mdomke/schwifty";
    license = licenses.mit;
    maintainers = with maintainers; [ milibopp ];
  };
}
