{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, linkify-it-py
, markdown-it-py
, mdformat
, mdformat-tables
, mdit-py-plugins
, pytest
, pytest-randomly
}:

buildPythonPackage rec {
  pname = "mdformat-gfm";
  version = "0.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "sha256-7sIa50jCN+M36Y0C05QaAL+TVwLzKxJ0gzpZI1YQFxg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "linkify" "linkify-it-py"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    linkify-it-py
    markdown-it-py
    mdformat
    mdformat-tables
    mdit-py-plugins
  ];

  checkInputs = [
    pytest
    pytest-randomly
  ];

  checkPhase = "pytest";

  meta = with lib; {
    description = "An mdformat plugin for GitHub Flavored Markdown compatibility";
    homepage = "https://github.com/hukkin/mdformat-gfm";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ djacu ];
  };
}
