{ lib
, buildPythonPackage
, cffi
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "2022.10.27";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k9msdxbqkBygv9GK47aPH2v1HeCDDD8jPvc0/NUqB5k=";
  };

  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
    cffi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cmarkgfm"
  ];

  meta = with lib; {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = "https://github.com/jonparrott/cmarkgfm";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
