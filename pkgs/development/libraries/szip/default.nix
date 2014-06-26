{ stdenv, fetchurl }:
    
stdenv.mkDerivation {
    name = "szip-2.1";
    src = fetchurl {
        url = ftp://ftp.hdfgroup.org/lib-external/szip/2.1/src/szip-2.1.tar.gz;
        sha256 = "1vym7r4by02m0yqj10023xyps5b21ryymnxb4nb2gs32arfxj5m8";
    };
}
