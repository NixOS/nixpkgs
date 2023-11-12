{
 BioPerl,
 IOString,
 buildPerlModule,
 fetchFromGitHub,
 fetchpatch,
 fetchurl,
 kent,
 lib,
 libmysqlclient,
 libpng,
 openssl,
 perl
}:

buildPerlModule rec {
  pname = "Bio-BigFile";
  version = "1.07";

  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LD/LDS/Bio-BigFile-${version}.tar.gz";
    sha256 = "277b66ce8acbdd52399e2c5a0cf4e3bd5c74c12b94877cd383d0c4c97740d16d";
  };

  # Only kent 335 works with Bio-BigFile, see
  # - official documentation: https://www.ensembl.org/info/docs/tools/vep/script/vep_download.html#bigfile
  # - one of the developer's answer: https://github.com/Ensembl/ensembl-vep/issues/1412
  # KENT_SRC is needed for building BioBigfil
  KENT_SRC = kent.overrideAttrs (old: rec {
    pname = "kent";
    version = "335";

    src = fetchFromGitHub {
      owner = "ucscGenomeBrowser";
      repo = "kent";
      rev = "v${version}_base";
      sha256 = "1455dwzpaq4hyhcqj3fpwgq5a39kp46qarfbr6ms6l2lz583r083";
    };

    # The first patch is a custom fix  for linking error with zlib.
    patches = [
      ./kent-utils.patch
      (fetchpatch {
        url = "https://github.com/ucscGenomeBrowser/kent/commit/316e4fd40f53c96850128fd65097a42623d1e736.patch";
        sha256 = "sha256-wr3NP5qoSonKz1TLKtQyrTPErCOk2gC1RimcX0tE7cM=";
      })];
  });


  buildInputs = [
    BioPerl
    IOString
    libpng
    libmysqlclient
    openssl
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://metacpan.org/dist/Bio-BigFile";
    description = "Manipulate Jim Kent's BigWig and BigBed index files for genomic features";
    license = licenses.unfree;
    maintainers = with maintainers; [ apraga ];
  };
}
