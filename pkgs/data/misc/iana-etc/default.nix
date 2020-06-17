{ stdenv, fetchzip }:

let
  version = "20200407";
in fetchzip {
  name = "iana-etc-${version}";
  url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
  sha256 = "1zmqim0l4lz5xbq7w2wi48fzsvg2msyw6c80dzw4vxll31frpy18";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    install -D -m0644 -t $out/etc services protocols
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Mic92/iana-etc";
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
