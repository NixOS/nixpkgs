{
  lib,
  buildDunePackage,
  fetchurl,
  riot,
  tty,
}:

buildDunePackage rec {
  pname = "minttea";
  version = "0.0.3";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/minttea/releases/download/${version}/minttea-${version}.tbz";
    hash = "sha256-WEaJVCCvsmKcF8+yzovljt8dGWaIv4UmAr74jq6Vo9M=";
  };

  propagatedBuildInputs = [
    riot
    tty
  ];

  meta = {
    description = "Fun, functional, and stateful way to build terminal apps in OCaml heavily inspired by Go's BubbleTea";
    homepage = "https://github.com/leostera/minttea";
    changelog = "https://github.com/leostera/minttea/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
}
