{ lib, fetchzip }:

let
  version = "2.1.53";

in fetchzip {
  name = "mailcap-${version}";

  url = "https://releases.pagure.org/mailcap/mailcap-${version}.tar.xz";
  sha256 = "sha256-6JPj2tZgoTEZ8hNEi9ZZhElBNm9SRTSXifMmCicwiLo=";

  postFetch = ''
    tar -xavf $downloadedFile --strip-components=1
    substituteInPlace mailcap --replace "/usr/bin/" ""
    gzip mailcap.5
    sh generate-nginx-mimetypes.sh < mime.types > nginx-mime.types

    install -D -m0644 nginx-mime.types $out/etc/nginx/mime.types
    install -D -m0644 -t $out/etc mailcap mime.types
    install -D -m0644 -t $out/share/man/man5 mailcap.5.gz
  '';

  meta = with lib; {
    description = "Helper application and MIME type associations for file types";
    homepage = "https://pagure.io/mailcap";
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}
