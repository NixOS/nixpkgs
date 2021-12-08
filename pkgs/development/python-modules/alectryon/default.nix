{ lib, buildPythonPackage, fetchFromGitHub
, pygments, dominate, beautifulsoup4, docutils, sphinx }:

buildPythonPackage rec {
  pname = "alectryon";
  version = "1.4.0";

  src = fetchFromGitHub {
     owner = "cpitclaudel";
     repo = "alectryon";
     rev = "v1.4.0";
     sha256 = "1vpsddfjxpvylq70r7ip6c0iaqn10jdkxmwd93r1zzkxg30hzsf3";
  };

  propagatedBuildInputs = [
    pygments
    dominate
    beautifulsoup4
    docutils
    sphinx
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cpitclaudel/alectryon";
    description = "A collection of tools for writing technical documents that mix Coq code and prose";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
