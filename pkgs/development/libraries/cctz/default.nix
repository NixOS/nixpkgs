{ lib, stdenv, fetchFromGitHub, Foundation }:

stdenv.mkDerivation rec {
  pname = "cctz";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cctz";
    rev = "v${version}";
    sha256 = "0254xfwscfkjc3fbvx6qgifr3pwkc2rb03z8pbvvqy098di9alhr";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  installTargets = [ "install_hdrs" ]
    ++ lib.optional (!stdenv.hostPlatform.isStatic) "install_shared_lib"
    ++ lib.optional stdenv.hostPlatform.isStatic "install_lib";

  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libcctz.so $out/lib/libcctz.so
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/google/cctz";
    description = "C++ library for translating between absolute and civil times";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
