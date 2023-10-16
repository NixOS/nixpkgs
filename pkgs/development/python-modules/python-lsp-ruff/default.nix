{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, ruff
, lsprotocol
, python-lsp-server
, tomli
}:

buildPythonPackage rec {
  pname = "python-lsp-ruff";
  version = "1.5.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "python-lsp-ruff";
    sha256 = "sha256-7vilIo1PHgHZ6yaRxTVt/bPwGt9g7rGvrq84eyIDIBw=";
  };

  postPatch = ''
    # ruff binary is used directly, the ruff python package is not needed
    sed -i '/"ruff>=/d' pyproject.toml
    sed -i 's|sys.executable, "-m", "ruff"|"${ruff}/bin/ruff"|' pylsp_ruff/plugin.py
  '';

  propagatedBuildInputs = [
    lsprotocol
    python-lsp-server
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/python-lsp/python-lsp-ruff";
    description = "Ruff linting plugin for pylsp";
    changelog = "https://github.com/python-lsp/python-lsp-ruff/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ linsui ];
  };
}
