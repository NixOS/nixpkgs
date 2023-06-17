{ lib
, stdenv
, pythonOlder
, buildPythonPackage
, fetchPypi
, ruff
, pygls
, lsprotocol
, hatchling
, typing-extensions
, pytestCheckHook
, python-lsp-jsonrpc
}:

buildPythonPackage rec {
  pname = "ruff-lsp";
  version = "0.0.31";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "ruff_lsp";
    hash = "sha256-cqkHhC0xK6+x82f10V2zW+tn97Nw0QSl+2w1ZBTjg+8=";
  };

  postPatch = ''
    # ruff binary added to PATH in wrapper so it's not needed
    sed -i '/"ruff>=/d' pyproject.toml
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pygls
    lsprotocol
    typing-extensions
  ];

  doCheck = stdenv.isDarwin;

  nativeCheckInputs = [
    pytestCheckHook
    python-lsp-jsonrpc
    ruff
  ];

  makeWrapperArgs = [
    # prefer ruff from user's PATH, that's usually desired behavior
    "--suffix PATH : ${lib.makeBinPath [ ruff ]}"
  ];

  meta = with lib; {
    description = "A Language Server Protocol implementation for Ruff";
    homepage = "https://github.com/astral-sh/ruff-lsp";
    changelog = "https://github.com/astral-sh/ruff-lsp/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
