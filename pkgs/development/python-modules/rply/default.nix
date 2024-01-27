{ lib
, fetchFromGitHub
, buildPythonPackage
, appdirs
, py
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rply";
  version = "0.7.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alex";
    repo = "rply";
    rev = "v${version}";
    hash = "sha256-5uINDCX4Jr4bSSwqBjvkS3f5wTMnZvsRGq1DeCw8Y+M=";
  };

  propagatedBuildInputs = [
    appdirs
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "A python Lex/Yacc that works with RPython";
    homepage = "https://github.com/alex/rply";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
