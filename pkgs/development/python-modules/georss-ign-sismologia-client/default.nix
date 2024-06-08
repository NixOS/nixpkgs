{
  lib,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "georss-ign-sismologia-client";
  version = "0.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ign-sismologia-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-geIxF4GumxRoetJ6mIZCzI3pAvWjJJoY66aQYd2Mzik=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    dateparser
    georss-client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_ign_sismologia_client" ];

  meta = with lib; {
    description = "Python library for accessing the IGN Sismologia GeoRSS feed";
    homepage = "https://github.com/exxamalte/python-georss-ign-sismologia-client";
    changelog = "https://github.com/exxamalte/python-georss-ign-sismologia-client/blob/v0.6/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
