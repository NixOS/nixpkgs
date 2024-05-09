{ lib
, fetchFromGitHub
, buildPythonPackage
, pyparsing
, six
, urwid
}:

buildPythonPackage rec {
  pname = "configshell";
  version = "1.1.30";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    hash = "sha256-7iWmYVCodwncoPdpw85zrNsZSEq+ume412lyiiJqRPc=";
  };

  propagatedBuildInputs = [
    pyparsing
    six
    urwid
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "configshell"
  ];

  meta = with lib; {
    description = "Python library for building configuration shells";
    homepage = "https://github.com/open-iscsi/configshell-fb";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
