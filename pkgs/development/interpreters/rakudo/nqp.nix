{ stdenv, fetchurl, perl, lib, moarvm }:

stdenv.mkDerivation rec {
  pname = "nqp";
  version = "2022.02";

  src = fetchurl {
    url = "https://github.com/raku/nqp/releases/download/${version}/nqp-${version}.tar.gz";
    sha256 = "sha256-JdPJl0XNhPQEmpvZzya7XcgXklq6r+ccm9tohBzbGLE=";
  };

  buildInputs = [ perl ];

  configureScript = "${perl}/bin/perl ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-moar=${moarvm}/bin/moar"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Not Quite Perl -- a lightweight Raku-like environment for virtual machines";
    homepage = "https://github.com/Raku/nqp";
    license = licenses.artistic2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}
