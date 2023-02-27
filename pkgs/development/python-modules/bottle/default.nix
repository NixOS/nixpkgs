{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.24";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JIASGnPoc4CYm3fjK9IJLRkOfqfXHm8bj3r36rnVTqM=";
  };

  nativeCheckInputs = [
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
