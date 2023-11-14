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
  version = "1.6.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "python-lsp-ruff";
    sha256 = "sha256-vf3ZNZyen1W29qk4ST1sus5VTcys9F3067NlUr406bg=";
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
