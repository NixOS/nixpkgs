{ lib
, buildPythonPackage
, fetchPypi
, click
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-spinner";
  version = "0.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "h+rPnXKYlzol12Fe9X1Hgq6/kTpTK7pLKKN+Nm6XXa8=";
  };

  nativeCheckInputs = [
    click
    six
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Add support for showwing that command line app is active to Click";
    homepage = "https://github.com/click-contrib/click-spinner";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
