{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "amrnb-7.0.0.2";
  srcAmr = fetchurl {
    url = http://www.3gpp.org/ftp/Specs/latest/Rel-7/26_series/26104-700.zip;
    sha256 = "0hgm8dddrqiinjdjxnsw0x899czjlvplq69z4kv8y4zqnrjlwzni";
  };

  src = fetchurl {
    url = http://ftp.penguin.cz/pub/users/utx/amr/amrnb-7.0.0.2.tar.bz2;
    sha256 = "0z4wjr0jml973vd0dvxlmy34daiswy5axlmpvc85k8qcr08i8zaa";
  };

  buildInputs = [ unzip ];

  configureFlags = [ "--cache-file=config.cache" "--with-downloader=true" ];

  postConfigure = ''
    cp $srcAmr 26104-700.zip 
  '';

  meta = {
    homepage = http://www.penguin.cz/~utx/amr;
    description = "AMR Narrow-Band Codec";
    # The wrapper code is free, but not the libraries from 3gpp.
    # It's a source code reference implementation with patents and licenses on
    # some countries, not redistributable.
    license = "unfree";
  };
}
