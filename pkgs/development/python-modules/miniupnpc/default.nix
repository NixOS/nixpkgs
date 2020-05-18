{ lib, buildPythonPackage, miniupnpc_2 }:

buildPythonPackage rec {
  pname = "miniupnpc";

  inherit (miniupnpc_2) version src nativeBuildInputs patches doCheck;

  meta = {
    description = "miniUPnP client";
    homepage = "http://miniupnp.free.fr/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
