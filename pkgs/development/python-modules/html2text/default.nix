{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2020.1.16";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Alir3z4";
    repo = pname;
    rev = version;
    sha256 = "1y924clp2hiqg3a9437z808p29mqcx537j5fmz71plx8qrcm5jf9";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "html2text" ];

  meta = with lib; {
    description = "Turn HTML into equivalent Markdown-structured text";
    homepage = "https://github.com/Alir3z4/html2text/";
    license = licenses.gpl3Only;
  };
}
