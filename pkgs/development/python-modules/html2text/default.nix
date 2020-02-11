{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytest
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2020.1.16";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Alir3z4";
    repo = pname;
    rev = version;
    sha256 = "1y924clp2hiqg3a9437z808p29mqcx537j5fmz71plx8qrcm5jf9";
  };

  # python setup.py test is broken, use pytest
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Turn HTML into equivalent Markdown-structured text";
    homepage = https://github.com/Alir3z4/html2text/;
    license = licenses.gpl3;
  };
}
