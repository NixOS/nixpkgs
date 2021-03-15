{ lib, stdenv, fetchFromGitHub, boehmgc, zlib, sqlite, pcre, cmake, pkg-config
, git, apacheHttpd, apr, aprutil, libmysqlclient, mbedtls, openssl, pkgs, gtk2, libpthreadstubs
}:

stdenv.mkDerivation rec {
  pname = "neko";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "neko";
    rev = "v${lib.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "19rc59cx7qqhcqlb0znwbnwbg04c1yq6xmvrwm1xi46k3vxa957g";
  };

  nativeBuildInputs = [ cmake pkg-config git ];
  buildInputs =
    [ boehmgc zlib sqlite pcre apacheHttpd apr aprutil
      libmysqlclient mbedtls openssl libpthreadstubs ]
      ++ lib.optional stdenv.isLinux gtk2
      ++ lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.Security
                                                pkgs.darwin.apple_sdk.frameworks.Carbon];
  cmakeFlags = [ "-DRUN_LDCONFIG=OFF" ];

  installCheckPhase = ''
    bin/neko bin/test.n
  '';

  doInstallCheck = true;
  dontPatchELF = true;
  dontStrip = true;

  meta = with lib; {
    description = "A high-level dynamically typed programming language";
    homepage = "https://nekovm.org";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber maintainers.locallycompact ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
