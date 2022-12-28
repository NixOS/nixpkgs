{ lib
, fetchFromGitHub
, buildPythonPackage
, pyparsing
, six
, urwid
}:

buildPythonPackage rec {
  pname = "configshell";
  version = "1.1.29";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "0mjj3c9335sph8rhwww7j4zvhyk896fbmx887vibm89w3jpvjjr9";
  };

  propagatedBuildInputs = [
    pyparsing
    six
    urwid
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyparsing >=2.0.2,<3.0" "pyparsing >=2.0.2"
  '';

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
