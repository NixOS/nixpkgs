{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "breathe";
  version = "4.34.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "michaeljones";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-OOc3XQjqQa0cVpA+/HHco+koL+0whUm5qC7x3xiEdwQ=";
  };

  propagatedBuildInputs = [
    docutils
    sphinx
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "breathe"
  ];

  meta = with lib; {
    description = "Sphinx Doxygen renderer";
    homepage = "https://github.com/michaeljones/breathe";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    inherit (sphinx.meta) platforms;
  };
}
