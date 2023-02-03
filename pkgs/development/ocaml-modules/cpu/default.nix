{ lib, stdenv, buildDunePackage, fetchFromGitHub, autoconf }:

buildDunePackage rec {
  pname = "cpu";
  version = "2.0.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1vir6gh1bhvxgj2fcn69c38yhw3jgk7dyikmw789m5ld2csnyjiv";
  };

  preConfigure = ''
    autoconf
    autoheader
  '';

  nativeBuildInputs = [ autoconf ];

  hardeningDisable = lib.optional stdenv.isDarwin "strictoverflow";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Core pinning library";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
