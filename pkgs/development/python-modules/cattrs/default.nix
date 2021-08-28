{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cattrs";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Tinche";
    repo = pname;
    rev = "v${version}";
    sha256 = "083d5mi6x7qcl26wlvwwn7gsp5chxlxkh4rp3a41w8cfwwr3h6l8";
  };

  propagatedBuildInputs = [ attrs ];

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cattr" ];

  meta = with lib; {
    description = "Python custom class converters for attrs";
    homepage = "https://github.com/Tinche/cattrs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
