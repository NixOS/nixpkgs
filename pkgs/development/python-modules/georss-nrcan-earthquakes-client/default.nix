{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "georss-nrcan-earthquakes-client";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-nrcan-earthquakes-client";
    rev = "v${version}";
    hash = "sha256-FFm37+dCkdoZXgvAjYhcHOYFf0oQ37bxJb7vzbWDTro=";
  };

  propagatedBuildInputs = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_nrcan_earthquakes_client" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for accessing Natural Resources Canada Earthquakes feed";
    homepage = "https://github.com/exxamalte/python-georss-nrcan-earthquakes-client";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python library for accessing Natural Resources Canada Earthquakes feed";
    homepage = "https://github.com/exxamalte/python-georss-nrcan-earthquakes-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
