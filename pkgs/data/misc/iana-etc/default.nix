{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iana-etc-${version}";
  version = "20180108";

  src = fetchurl {
    url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
    sha256 = "1x4jacrvjwcsan88rg2wf2a8bajsglg6w4396vbr18zh0sya84a2";
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
