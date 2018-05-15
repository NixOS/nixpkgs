{ stdenv, fetchurl, lib }:

let

  generic = { version, sha256 }: stdenv.mkDerivation rec {
    name = "libressl-${version}";
    inherit version;

    src = fetchurl {
      url = "mirror://openbsd/LibreSSL/${name}.tar.gz";
      inherit sha256;
    };

    configureFlags = [ "--enable-nc" ];

    enableParallelBuilding = true;

    outputs = [ "bin" "dev" "out" "man" "nc" ];

    postFixup = ''
      moveToOutput "bin/nc" "$nc"
      moveToOutput "share/man/man1/nc.1${lib.optionalString (dontGzipMan==null) ".gz"}" "$nc"
    '';

    dontGzipMan = if stdenv.isDarwin then true else null; # not sure what's wrong

    meta = with lib; {
      description = "Free TLS/SSL implementation";
      homepage    = "https://www.libressl.org";
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
    version = "2.6.4";
    sha256 = "07yi37a2ghsgj2b4w30q1s4d2inqnix7ika1m21y57p9z71212k3";
  };

  libressl_2_7 = generic {
    version = "2.7.3";
    sha256 = "1597kj9jy3jyw52ys19sd4blg2gkam5q0rqdxbnrnvnyw67hviqn";
  };
}
