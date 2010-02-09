{stdenv, fetchurl, m4}:

stdenv.mkDerivation rec {
  name = "libmilter-8.14.4";
  
  src = fetchurl {
    url = "ftp://ftp.sendmail.org/pub/sendmail/sendmail.8.14.4.tar.gz";
    sha256 = "1cbwz5ynl8snrdkl7ay1qhqknbyv0qsvdvcri7mb662hgi1hj0dw";
  };

  buildPhase = '' 
    ensureDir $out/lib
    cd libmilter
    cat > a.m4 <<EOF
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
    EOF
    sh Build -f ./a.m4
  '';

  patches = [ ./install.patch ];
  
  buildInputs = [m4];
}
