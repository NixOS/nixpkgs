{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "2.0.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d01077dbfca7aa53f3ef4adecccce636bce4f82e5b52237703ab2f56478e56e";
  };

  propagatedBuildInputs = [ importlib-metadata ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    changelog = "https://github.com/explosion/catalogue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
