{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, mdformat
, pytestCheckHook
,
}:
buildPythonPackage rec {
  pname = "mdformat-toc";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "sha256-3EX6kGez408tEYiR9VSvi3GTrb4ds+HJwpFflv77nkg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    mdformat
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Mdformat plugin to generate a table of contents";
    homepage = "https://github.com/hukkin/mdformat-toc";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ polarmutex ];
  };
}
