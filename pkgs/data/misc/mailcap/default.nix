{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mailcap";
  version = "2.1.53";

  src = fetchurl {
    url = "https://releases.pagure.org/mailcap/mailcap-${version}.tar.xz";
    sha256 = "sha256-Xuou8XswSXe6PsuHr61DGfoEQPgl5Pb7puj6L/64h4U=";
  };

  patches = [
    ./update-mime-types.patch
  ];

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
