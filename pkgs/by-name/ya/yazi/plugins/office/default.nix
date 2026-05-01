{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "office.yazi";
  version = "0-unstable-2026-04-22";

  src = fetchFromGitHub {
    owner = "macydnah";
    repo = "office.yazi";
    rev = "41ebef8be9dded98b5179e8af65be71b30a1ac4d";
    hash = "sha256-QFto48D+Z8qHl7LHoDDprvr5mIJY8E7j37cUpRjKdNk=";
  };

  meta = {
    description = "A plugin to preview office documents in Yazi";
    homepage = "https://github.com/macydnah/office.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nemeott ];
  };
}
