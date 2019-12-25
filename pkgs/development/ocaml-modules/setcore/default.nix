{ stdenv, buildDunePackage, fetchFromGitHub, autoconf }:

buildDunePackage rec {
  pname = "setcore";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1yn660gxk2ccp7lbdq9v6pjz1c3pm08s9dl9k9l5492ld6bx8fxc";
  };

  preConfigure = ''
    autoconf
    autoheader
  '';

  buildInputs = [ autoconf ];

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "strictoverflow";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
