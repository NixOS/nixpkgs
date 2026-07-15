{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "georss-nrcan-earthquakes-client";
  version = "0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-nrcan-earthquakes-client";
    rev = "v${version}";
    hash = "sha256-FFm37+dCkdoZXgvAjYhcHOYFf0oQ37bxJb7vzbWDTro=";
  };

  propagatedBuildInputs = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_nrcan_earthquakes_client" ];

  meta = {
    description = "Python library for accessing Natural Resources Canada Earthquakes feed";
    homepage = "https://github.com/exxamalte/python-georss-nrcan-earthquakes-client";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
