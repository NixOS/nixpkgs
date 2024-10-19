{ lib, stdenv, fetchFromGitHub, Foundation }:

stdenv.mkDerivation rec {
  pname = "cctz";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cctz";
    rev = "v${version}";
    sha256 = "sha256-F4h8nT1karymV16FFHC0ldSbdOOx5AMstqi4Bc5m3UQ=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Foundation;

  installTargets = [ "install_hdrs" ]
    ++ lib.optional (!stdenv.hostPlatform.isStatic) "install_shared_lib"
    ++ lib.optional stdenv.hostPlatform.isStatic "install_lib";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
