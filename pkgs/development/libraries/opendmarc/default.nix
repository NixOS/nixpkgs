{ lib, stdenv, fetchFromGitHub, autoreconfHook, libmilter, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "opendmarc";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "trusteddomainproject";
    repo = "opendmarc";
    rev = "rel-opendmarc-${builtins.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-SQH85FLfVEEtYhR1+A1XxCDMiTjDgLQX6zifbLxCa5c=";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  buildInputs = [ perl ];
  nativeBuildInputs = [ autoreconfHook makeWrapper ];

  postPatch = ''
    substituteInPlace configure.ac --replace '	docs/Makefile' ""
    patchShebangs contrib reports
  '';

  configureFlags = [
    "--with-milter=${libmilter}"
  ];

  postFixup = ''
    for b in $bin/bin/opendmarc-{expire,import,params,reports}; do
      wrapProgram $b --set PERL5LIB ${perlPackages.makeFullPerlPath (with perlPackages; [ Switch DBI DBDmysql HTTPMessage ])}
    done
  '';

  meta = with lib; {
    description = "A free open source software implementation of the DMARC specification";
    homepage = "http://www.trusteddomain.org/opendmarc/";
    license = with licenses; [ bsd3 sendmail ];
    maintainers = teams.helsinki-systems.members;
  };
}
