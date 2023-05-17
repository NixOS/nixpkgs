{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "illwill";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "johnnovak";
    repo = "illwill";
    rev = "v${version}";
    hash = "sha256-9YBkad5iUKRb375caAuoYkfp5G6KQDhX/yXQ7vLu/CA=";
  };

  meta = with lib;
    src.meta // {
      description = "A curses inspired simple cross-platform console library for Nim";
      license = [ licenses.wtfpl ];
      maintainers = with maintainers; [ sikmir ];
    };
}
