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
, unittestCheckHook
, python-lsp-jsonrpc
}:

buildPythonPackage rec {
  pname = "ruff-lsp";
  version = "0.0.24";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "ruff_lsp";
    sha256 = "sha256-1he/GYk8O9LqPXH3mu7eGWuRygiDG1OnJ+JNT2Pynzo=";
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
    unittestCheckHook
    python-lsp-jsonrpc
    ruff
  ];

  makeWrapperArgs = [
    # prefer ruff from user's PATH, that's usually desired behavior
    "--suffix PATH : ${lib.makeBinPath [ ruff ]}"
  ];


  meta = with lib; {
    homepage = "https://github.com/charliermarsh/ruff-lsp";
    description = "A Language Server Protocol implementation for Ruff";
    changelog = "https://github.com/charliermarsh/ruff-lsp/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
