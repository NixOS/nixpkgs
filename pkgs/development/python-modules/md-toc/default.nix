{ lib
, buildPythonPackage
, fetchFromGitHub
, fpyutils
, pyfakefs
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "md-toc";
  version = "8.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = version;
    hash = "sha256-7bXd+kTB1NF5KfcDVsvemCfIbZxv6nAw851bNo375Xs=";
  };

  propagatedBuildInputs = [
    fpyutils
  ];

  checkInputs = [
    pyfakefs
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "md_toc/tests/*.py"
  ];

  pythonImportsCheck = [
    "md_toc"
  ];

  meta = with lib; {
    description = "Table of contents generator for Markdown";
    homepage = "https://docs.franco.net.eu.org/md-toc/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
