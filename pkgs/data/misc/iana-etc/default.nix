{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iana-etc-2.30";

  src = fetchurl {
    url = "http://sethwklein.net/${name}.tar.bz2";
    sha256 = "03gjlg5zlwsdk6qyw3v85l129rna5bpm4m7pzrp864h0n97qg9mr";
  };

  preInstall = "installFlags=\"PREFIX=$out\"";

  meta = {
    homepage = http://sethwklein.net/iana-etc;
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = stdenv.lib.platforms.unix;
  };
}
