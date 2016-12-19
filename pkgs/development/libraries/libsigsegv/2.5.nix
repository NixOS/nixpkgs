{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsigsegv-2.5";

  src = fetchurl {
    url = "mirror://gnu/libsigsegv/${name}.tar.gz";
    sha256 = "0fvcsq9msi63vrbpvks6mqkrnls5cfy6bzww063sqhk2h49vsyyg";
  };

  meta = {
    homepage = http://libsigsegv.sf.net;
    description = "A library for handling page faults in user mode";
    branch = "2.5";
    platforms = stdenv.lib.platforms.linux;
  };

  doCheck = true;
}
