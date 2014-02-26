{stdenv, fetchurl, m4}:

stdenv.mkDerivation rec {
  name = "libmilter-8.14.8";
  
  src = fetchurl {
    url = "ftp://ftp.sendmail.org/pub/sendmail/sendmail.8.14.8.tar.gz";
    sha256 = "1zmhzkj3gzx8022hsrysr3nzlcmv1qisb5i4jbx91661bw96ksq2";
  };

  buildPhase = '' 
    mkdir -p $out/lib
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

  patches = [ ./install.patch ./sharedlib.patch];
  
  buildInputs = [m4];
}
