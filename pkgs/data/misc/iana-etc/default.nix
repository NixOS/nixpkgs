{ lib, fetchzip }:

let
  version = "20200729";
in fetchzip {
  name = "iana-etc-${version}";
  url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
  sha256 = "05cymmisfvpyd7fwzc6axvm5fsi1v6hzs0pjr4xp1i95wvpz7qpm";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    install -D -m0644 -t $out/etc services protocols
  '';

  meta = with lib; {
    homepage = "https://github.com/Mic92/iana-etc";
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
