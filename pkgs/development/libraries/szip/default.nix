{ stdenv, fetchurl }:
    
stdenv.mkDerivation {
    name = "szip-2.1";
    src = fetchurl {
        url = ftp://ftp.hdfgroup.org/lib-external/szip/2.1/src/szip-2.1.tar.gz;
        sha256 = "05707lrdhwp8mv0dgzh2b6m2mwamv1z6k29m2v1v7pz0c1w2gb6z";
    };
}