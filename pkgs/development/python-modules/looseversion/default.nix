{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "looseversion";
  version = "1.1.2";
  format = "flit";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-lNgL29C21XwRuIYUe6FgH30VMVcWIbgZM7NFN8vkaa0=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = [ "tests.py" ];
  pythonImportsCheck = [ "looseversion" ];

  meta = with lib; {
    description = "Version numbering for anarchists and software realists";
    homepage = "https://github.com/effigies/looseversion";
    license = licenses.psfl;
    maintainers = with maintainers; [ pelme ];
  };
}
