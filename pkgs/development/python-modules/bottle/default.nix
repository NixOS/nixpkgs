{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.21";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "787c61b6cc02b9c229bf2663011fac53dd8fc197f7f8ad2eeede29d888d7887e";
  };

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    cd test
  '';

  disabledTests = [
    "test_delete_cookie"
    "test_error"
    "test_error_in_generator_callback"
  ];

  meta = with lib; {
    homepage = "https://bottlepy.org/";
    description = "A fast and simple micro-framework for small web-applications";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
