{ lib
, buildPythonPackage
, fetchFromGitHub
, black
, toml
, pytestCheckHook
, python-lsp-server
, isPy3k
}:

buildPythonPackage rec {
  pname = "python-lsp-black";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
    rev = "v${version}";
    sha256 = "1blxhj70jxb9xfbd4dxqikd262n6dn9dw5qhyml5yvdwxbv0bybc";
  };

  disabled = !isPy3k;

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ black toml python-lsp-server ];

  meta = with lib; {
    homepage = "https://github.com/python-lsp/python-lsp-black";
    description = "python-lsp-server plugin that adds support to black autoformatter";
    license = licenses.mit;
    maintainers = [ yourfavouriteuncle ];
  };
}
