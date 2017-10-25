{ stdenv, fetchurl }:

let

  generic = { version, sha256 }: stdenv.mkDerivation rec {
    name = "libressl-${version}";
    inherit version;

    src = fetchurl {
      url = "mirror://openbsd/LibreSSL/${name}.tar.gz";
      inherit sha256;
    };

    enableParallelBuilding = true;

    outputs = [ "bin" "dev" "out" "man" ];

    dontGzipMan = if stdenv.isDarwin then true else null; # not sure what's wrong

    meta = with stdenv.lib; {
      description = "Free TLS/SSL implementation";
      homepage    = "http://www.libressl.org";
      platforms   = platforms.all;
      maintainers = with maintainers; [ thoughtpolice wkennington fpletz globin ];
    };
  };

in {

  libressl_2_5 = generic {
    version = "2.5.5";
    sha256 = "1i77viqy1afvbr392npk9v54k9zhr9zq2vhv6pliza22b0ymwzz5";
  };

  libressl_2_6 = generic {
    version = "2.6.2";
    sha256 = "0y64grb2zx98rjp2lbwihyhbml4z5ih3v7ydbxdvmabj5d4x4adh";
  };
}
