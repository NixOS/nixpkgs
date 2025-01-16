{
  buildPythonPackage,
  typing-extensions,
  fetchPypi,
  lib,
  nix-update-script,
  hatch-vcs,
  pythonOlder,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "manifestoo-core";
  version = "1.8.1";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "manifestoo_core";
    hash = "sha256-aULT5xxkWEndzEBVcpwvWlIXQYxwfF0VxoI6EHC3JAs=";
  };

  nativeBuildInputs = [ hatch-vcs ];

  propagatedBuildInputs =
    lib.optionals (pythonOlder "3.7") [ importlib-resources ]
    ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo-core";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ yajo ];
  };
}
