{ lib
, buildPythonPackage
, fetchFromGitHub
, fpyutils
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "md-toc";
  version = "8.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = version;
    sha256 = "sha256-nh9KxjwF+O4n0qVo9yPP6fvKB5XFICh+Ak6oD2fQVdk=";
  };

  propagatedBuildInputs = [
    fpyutils
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "fpyutils>=2.0,<2.1" "fpyutils>=2.0,<3"
  '';

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
