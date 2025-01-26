{
  buildPythonPackage,
  lib,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "litestar-htmx";
  version = "0.4.1";

  src = fetchPypi {
    pname = "litestar_htmx";
    inherit version;
    hash = "sha256-uiU3AI64zBi/yL7lzssoCSTHgYuxwGbXnq5LIhaWygg=";
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
