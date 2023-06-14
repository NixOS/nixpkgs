{ buildPythonPackage
, fetchPypi
, lib
, nix-update-script
, pythonOlder
}:
buildPythonPackage rec {
  pname = "pkgutil_resolve_name";
  version = "1.3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NX1snmp1VlPP14iTgXwIU682XdUeyX89NYqBk3O70XQ=";
  };
  format = "flit";
  disabled = pythonOlder "3.7";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://pypi.org/project/pkgutil_resolve_name/";
    description = "A backport of Python 3.9’s pkgutil.resolve_name.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
