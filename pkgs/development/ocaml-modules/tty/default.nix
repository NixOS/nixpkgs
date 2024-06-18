{ lib
, buildDunePackage
, fetchurl
, uutf
}:

buildDunePackage rec {
  pname = "tty";
  version = "0.0.2";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/tty/releases/download/${version}/tty-${version}.tbz";
    hash = "sha256-eeD5Y+/QXZzFoEHvOSZj2Q74V8BK5j3Lu3Zsrj2YUUs=";
  };

  propagatedBuildInputs = [
    uutf
  ];

  doCheck = true;

  meta = {
    description = "Library for interacting with teletype and terminal emulators";
    homepage = "https://github.com/leostera/tty";
    changelog = "https://github.com/leostera/tty/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
}
