{ stdenv, fetchurl, m4 }:

stdenv.mkDerivation rec {
  pname = "libmilter";
  version = "8.15.2";

  src = fetchurl {
    url = "ftp://ftp.sendmail.org/pub/sendmail/sendmail.${version}.tar.gz";
    sha256 = "0fdl9ndmspqspdlmghzxlaqk56j3yajk52d7jxcg21b7sxglpy94";
  };

  buildPhase = ''
    mkdir -p $out/lib
    cd libmilter
    cat > a.m4 <<EOF
      define(\`confCC', \`$CC')
      define(\`confAR', \`$AR')
      define(\`confEBINDIR', \`$out/libexec')
      define(\`confINCLUDEDIR', \`$out/include')
      define(\`confLIBDIR', \`$out/lib')
      define(\`confMANROOT', \`$out/man/cat')
      define(\`confMANROOTMAN', \`$out/man/man')
      define(\`confMBINDIR', \`$out/sbin')
      define(\`confSBINDIR', \`$out/sbin')
      define(\`confSHAREDLIBDIR', \`$out/lib')
      define(\`confUBINDIR', \`$out/bin')
      define(\`confINCGRP', \`root')
      define(\`confLIBGRP', \`root')
      APPENDDEF(\`confENVDEF', \`-DNETINET6')
    EOF
    sh Build -f ./a.m4
  '';

  patches = [ ./install.patch ./sharedlib.patch ./glibc-2.30.patch ];

  nativeBuildInputs = [ m4 ];

  meta = with stdenv.lib; {
    description = "Sendmail Milter mail filtering API library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.sendmail;
  };
}
