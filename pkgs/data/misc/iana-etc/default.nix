{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iana-etc-${version}";
  version = "20180405";

  src = fetchurl {
    url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
    sha256 = "0x6i95arrc4lcq2il3r05hbnd9vsi87z4yc8s3agkvbj74d6hfhj";
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
