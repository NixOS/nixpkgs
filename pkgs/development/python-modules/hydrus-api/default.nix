{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "hydrus-api";
  version = "4.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4by2TlZJIKElGgaof1w555ik2hUNbg16YekSWwICGmg=";
  };

  disabled = pythonOlder "3.9";

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [ "hydrus_api" ];

  # There are no unit tests
  doCheck = false;

  meta = with lib; {
    description = "Python module implementing the Hydrus API";
    homepage = "https://gitlab.com/cryzed/hydrus-api";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
