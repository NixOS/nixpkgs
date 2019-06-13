{ lib, fetchzip }:

let
  version = "2.1.48";

in fetchzip {
  name = "mailcap-${version}";

  url = "https://releases.pagure.org/mailcap/mailcap-${version}.tar.xz";
  sha256 = "0m1rls4z85aby9fggwx2x70b4y6l0jjyiqdv30p8g91nv8hrq9fw";

  postFetch = ''
    tar -xavf $downloadedFile --strip-components=1
    substituteInPlace mailcap --replace "/usr/bin/" ""
    gzip mailcap.4

    install -D -m0644 -t $out/etc mailcap mime.types
    install -D -m0644 -t $out/share/man/man4 mailcap.4.gz
  '';

  meta = with lib; {
    description = "Helper application and MIME type associations for file types";
    homepage = "https://pagure.io/mailcap";
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}
