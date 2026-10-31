{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "wl-pprint";
  version = "2017-03-13";

  src = fetchFromGitHub {
    owner = "shayan-najd";
    repo = "wl-pprint";
    rev = "97590d1679b3db07bb430783988b4cba539e9947";
    hash = "sha256-rVA+803ElTt/2p8GuEfZO2Jz3k6mW/XnlICMh5k510U=";
  };

  meta = {
    description = "Wadler-Leijen pretty-printing library";
    homepage = "https://github.com/shayan-najd/wl-pprint";
    license = lib.licenses.bsd2;
  };
}
