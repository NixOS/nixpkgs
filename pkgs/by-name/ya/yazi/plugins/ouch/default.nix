{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "ouch.yazi";
  version = "0-unstable-2025-06-01";

  src = fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    rev = "10b462765f37502065555e83c68a72bb26870fe2";
    hash = "sha256-mtXl76a54Deg4cyrD0wr++sD/5b/kCsnJ+ngM6OokTc=";
  };

  meta = {
    description = "Yazi plugin to preview archives";
    homepage = "https://github.com/ndtoan96/ouch.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
