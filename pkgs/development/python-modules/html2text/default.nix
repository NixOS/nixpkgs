{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytest
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2019.9.26";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Alir3z4";
    repo = pname;
    rev = version;
    sha256 = "1gzcx4n6q71plq4zvb1z0fy3brrln0qqrd6jc89iiqn7r1ix8h87";
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
