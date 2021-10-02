{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "0.1.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NlMvd8yABZTo8WZB7a5/G695MvBdjlCFRblfxTxtyFs=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "iso8601" ];

  pythonImportsCheck = [ "iso8601" ];

  meta = with lib; {
    description = "Simple module to parse ISO 8601 dates";
    homepage = "https://pyiso8601.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
