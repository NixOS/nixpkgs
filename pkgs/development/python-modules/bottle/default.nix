{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.23";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aD3jqjmfsm6HsnTbz3CxplE4XUWRMXFjh6vcN5LgQWc=";
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
