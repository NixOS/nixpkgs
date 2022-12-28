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
  version = "8.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = version;
    hash = "sha256-Wtb2xHBj6RYVfUkPmRMxUti7UBj1PVh9ZCDienYX4Bw=";
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
    changelog = "https://blog.franco.net.eu.org/software/CHANGELOG-md-toc.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
