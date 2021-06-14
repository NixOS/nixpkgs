{ lib, fetchzip }:

let
  version = "20210225";
in fetchzip {
  name = "iana-etc-${version}";
  url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
  sha256 = "sha256-NVvZG3EJEYOXFDTBXD5m9sg/8msyMiBMkiZr+ZxWZ/g=";

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
