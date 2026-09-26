{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "ouch.yazi";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    tag = "v0.7.1";
    hash = "sha256-CSthsFIiIa81xHgs2Szoy9atRouRESHOPxUt/pOtvl0=";
  };

  meta = {
    description = "Yazi plugin to preview archives";
    homepage = "https://github.com/ndtoan96/ouch.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
