{
  buildPythonPackage,
  lib,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "litestar-htmx";
  version = "0.5.0";

  src = fetchPypi {
    pname = "litestar_htmx";
    inherit version;
    hash = "sha256-4C0aOpIXLIdINfo+Z0nWWun8Ym0N9GcZSQoWKT4hRvs=";
  };

  pyproject = true;

  build-system = [
    hatchling
  ];

  meta = {
    homepage = "https://docs.litestar.dev/latest/usage/htmx.html";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    description = "HTMX Integration for Litesstar";
  };
}
