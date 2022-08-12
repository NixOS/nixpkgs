{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "httplib";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${version}";
    sha256 = "sha256-rsElqtoRz/sOXpAsfSJbMlwIKdaGJkSZfKHzB/wMhY8=";
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
    maintainers = with maintainers; [ aidalgol ];
    license = licenses.mit;
  };
}
