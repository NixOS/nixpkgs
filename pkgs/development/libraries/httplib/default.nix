{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "httplib";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${version}";
    hash = "sha256-Qr8jaZSj5xPiTF8reur09/R2jrtDk5hxHKeVTccHbZQ=";
  };

  # Header-only library.
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/include"
    cp -r httplib.h "$out/include"
  '';

  meta = with lib; {
    description = "A C++ header-only HTTP/HTTPS server and client library";
    homepage = "https://github.com/yhirose/cpp-httplib";
    changelog = "https://github.com/yhirose/cpp-httplib/releases/tag/v${version}";
    maintainers = with maintainers; [ aidalgol ];
    license = licenses.mit;
  };
}
