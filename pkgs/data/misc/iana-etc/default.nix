{ stdenv, fetchzip }:

let
  version = "20181219";
in fetchzip {
  name = "iana-etc-${version}";
  url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
  sha256 = "0i3f7shvf1g6dp984w8xfix6id3q5c10b292wz2qw3v5n7h6wkm3";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    install -D -m0644 -t $out/etc services protocols
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Mic92/iana-etc;
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
