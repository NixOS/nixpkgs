{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, future
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "grandalf";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdcht";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j2SvpQvDMfwoj2PAQSxzEIyIzzJ61Eb9wgetKyni6A4=";
  };

  propagatedBuildInputs = [
    pyparsing
    future
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    ./no-setup-requires-pytestrunner.patch
  ];

  pythonImportsCheck = [
    "grandalf"
  ];

  meta = with lib; {
    description = "Module for experimentations with graphs and drawing algorithms";
    homepage = "https://github.com/bdcht/grandalf";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
