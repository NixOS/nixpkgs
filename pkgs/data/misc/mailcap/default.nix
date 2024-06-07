{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mailcap";
  version = "2.1.54";

  src = fetchurl {
    url = "https://releases.pagure.org/mailcap/mailcap-${version}.tar.xz";
    hash = "sha256-mkAyIC/A0rCFj0GxZzianP5SrCTsKC5kebkHZTGd4RM=";
  };

  installPhase = ''
    runHook preInstall

    substituteInPlace mailcap --replace "/usr/bin/" ""
    sh generate-nginx-mimetypes.sh < mime.types > nginx-mime.types

    install -D -m0644 nginx-mime.types $out/etc/nginx/mime.types
    install -D -m0644 -t $out/etc mailcap mime.types
    install -D -m0644 -t $out/share/man/man5 mailcap.5

    runHook postInstall
  '';

  meta = with lib; {
    description = "Helper application and MIME type associations for file types";
    homepage = "https://pagure.io/mailcap";
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}
