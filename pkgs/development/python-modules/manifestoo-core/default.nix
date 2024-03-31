{ buildPythonPackage
, typing-extensions
, fetchPypi
, lib
, nix-update-script
, hatch-vcs
, pythonOlder
, importlib-resources
}:

buildPythonPackage rec {
  pname = "manifestoo-core";
  version = "1.5";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "manifestoo_core";
    hash = "sha256-a3v2WfJ42bh2LlAsH9ekpLFsAlOiTTLGNknTW2mTxCI=";
  };

  nativeBuildInputs = [
    hatch-vcs
  ];

  propagatedBuildInputs =
    lib.optionals (pythonOlder "3.7") [ importlib-resources ]
    ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A library to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo-core";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ yajo ];
  };
}
