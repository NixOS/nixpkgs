{
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  lib,
  nix-update-script,
  pythonOlder,
  flit-core,
}:
buildPythonPackage rec {
  pname = "pkgutil-resolve-name";
  version = "1.3.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pkgutil_resolve_name";
    inherit version;
    hash = "sha256-NX1snmp1VlPP14iTgXwIU682XdUeyX89NYqBk3O70XQ=";
  };

  patches = [
    # Raise flit-core version constrains
    (fetchpatch {
      # https://github.com/graingert/pkgutil-resolve-name/pull/5
      url = "https://github.com/graingert/pkgutil-resolve-name/commit/042834290c735fa836bb308ce9e93c9f64d67cbe.patch";
      hash = "sha256-M1rcrkdFcoFa3IncPnJaRhnXbelyk56QnMGtmgB6bvk=";
    })
  ];

  nativeBuildInputs = [ flit-core ];

  # has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://pypi.org/project/pkgutil_resolve_name/";
    description = "Backport of Python 3.9’s pkgutil.resolve_name";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
