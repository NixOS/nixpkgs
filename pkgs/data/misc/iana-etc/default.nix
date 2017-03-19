{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iana-etc-${version}";
  version = "20170328";

  src = fetchurl {
    url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
    sha256 = "0c0zgijmh035wan3pvz8ykkmkdbraml4b9kx36b4j1lj9fhgy1yk";
  };

  installPhase = ''
    mkdir -p $out/etc
    cp services protocols $out/etc/
  '';

  meta = {
    homepage = https://github.com/Mic92/iana-etc;
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = stdenv.lib.platforms.unix;
  };
}
