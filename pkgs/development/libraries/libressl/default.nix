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
      license = with licenses; [ publicDomain bsdOriginal bsd0 bsd3 gpl3 isc ];
      platforms   = platforms.all;
      maintainers = with maintainers; [ thoughtpolice wkennington fpletz globin ];
    };
  };

in {

  libressl_2_6 = generic {
    version = "2.6.5";
    sha256 = "0anx9nlgixdjn811zclim85jm5yxmxwycj71ix27rlhr233xz7l5";
  };

  libressl_2_7 = generic {
    version = "2.7.4";
    sha256 = "19kxa5i97q7p6rrps9qm0nd8zqhdjvzx02j72400c73cl2nryfhy";
  };

  libressl_2_8 = generic {
    version = "2.8.0";
    sha256 = "1hwxg14d6a9wgk360dvi0wfzw7b327a95wf6xqc3a1h6bfbblaxg";
  };
}
