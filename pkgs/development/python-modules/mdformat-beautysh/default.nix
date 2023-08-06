{ lib
, beautysh
, buildPythonPackage
, fetchFromGitHub
, mdformat
, mdformat-gfm
, mdit-py-plugins
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-beautysh";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mH9PN6QsPmnIzh/0vxa+5mYLzANUHRruXC0ql4h8myw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    mdformat
    mdformat-gfm
    mdit-py-plugins
  ];

  propagatedBuildInputs = [
    beautysh
  ];

  meta = with lib; {
    description = "Mdformat plugin to beautify Bash scripts";
    homepage = "https://github.com/hukkin/mdformat-beautysh";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
