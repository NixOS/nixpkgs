{ lib
, buildPythonPackage
, fetchFromGitHub
, fpyutils
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "md-toc";
  version = "7.2.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = version;
    sha256 = "1v74iddfk5d6170frg89vzrkz9xrycl1f50g59imc7x7g50i6c2x";
  };

  propagatedBuildInputs = [
    fpyutils
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "fpyutils>=1.2,<1.3" "fpyutils>=1.2"
  '';

  pytestFlagsArray = [ "md_toc/tests/*.py" ];

  pythonImportsCheck = [ "md_toc" ];

  meta = with lib; {
    description = "Table of contents generator for Markdown";
    homepage = "https://docs.franco.net.eu.org/md-toc/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
