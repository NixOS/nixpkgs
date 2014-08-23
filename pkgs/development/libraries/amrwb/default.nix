{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  # The 'src' 7.0.0.3 expects amrwb 700, but there is only 710 available now,
  # so I guess in 3gpp they updated to 7.1.0, but amrwb did not update the libraries.
  # I guess amrwb uses the first version numbers to match those of 3gpp,
  # so I set the name to 7.1.0.3 in this case
  name = "amrwb-7.1.0.3";

  srcAmr = fetchurl {
    url = http://www.3gpp.org/ftp/Specs/latest/Rel-7/26_series/26204-710.zip;
    sha256 = "1wnx72m20y8bdlyndyy8rskr0hi4llk1h1hcr34awxfmi9l4922i";
  };

  src = fetchurl {
    url = http://ftp.penguin.cz/pub/users/utx/amr/amrwb-7.0.0.3.tar.bz2;
    sha256 = "0nn94i3gw3d5fgks43wdhshdlhpd4rcrzj46f2vsby0viwkxxp8z";
  };

  buildInputs = [ unzip ];

  patchPhase = ''
    sed -i s/26204-700/26204-710/g Makefile.am Makefile.in configure configure.ac \
      prepare_sources.sh.in
  '';

  configureFlags = [ "--cache-file=config.cache" "--with-downloader=true" ];

  postConfigure = ''
    cp $srcAmr 26204-710.zip 
  '';

  meta = {
    homepage = http://www.penguin.cz/~utx/amr;
    description = "AMR Wide-Band Codec";
    # The wrapper code is free, but not the libraries from 3gpp.
    # It's a source code reference implementation with patents and licenses on
    # some countries, not redistributable.
    license = stdenv.lib.licenses.unfree;
  };
}
