args: with args;

stdenv.mkDerivation rec {
  name = "libsigsegv-" + version;
  src = fetchurl {
    url = "mirror://gnu/libsigsegv/${name}.tar.gz";
    sha256 = "0fvcsq9msi63vrbpvks6mqkrnls5cfy6bzww063sqhk2h49vsyyg";
  };

  meta = {
    homepage = http://libsigsegv.sf.net;
    description = "A library for handling page faults in user mode";
  };

  configureFlags = "--enable-shared --disable-static";
  doCheck = true;
}
