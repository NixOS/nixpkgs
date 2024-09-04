{ pkgs, lib, fetchFromGitHub, libxml2, ... }:

{
  pname = "gerbil-libxml";
  version = "unstable-2023-09-23";
  git-version = "b08e5d8";
  gerbil-package = "clan";
  gerbilInputs = [ ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ libxml2 ];
  version-path = "";
  softwareName = "Gerbil-LibXML";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-libxml";
    rev = "b08e5d8fe4688a162824062579ce152a10adb4cf";
    sha256 = "1zfccqaibwy2b3srwmwwgv91dwy1xl18cfimxhcsxl6mxvgm61pd";
  };

  meta = with lib; {
    description = "libxml bindings for Gerbil";
    homepage    = "https://github.com/mighty-gerbils/gerbil-libxml";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
