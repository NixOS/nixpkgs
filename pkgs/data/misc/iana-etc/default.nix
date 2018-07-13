{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iana-etc-${version}";
  version = "20180711";

  src = fetchurl {
    url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
    sha256 = "0xigkz6pcqx55px7fap7j6p3hz27agv056crbl5pgfcdix7y8z26";
  };

  installPhase = ''
    install -D -t $out/etc services protocols
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Mic92/iana-etc;
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
