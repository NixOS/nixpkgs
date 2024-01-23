# Instructions:http://www.ensembl.org/info/docs/api/api_installation.html
# Do not use https://github.com/Ensembl/ensembl-vep/archive/release/${version}.zip
# We cannot use INSTALL.pl but it’s not that bad:install the dependencies and copies the .pm files should be ok
{ config
, curl
, lib
, perlPackages
, pkgs
, stdenv
, fetchFromGitHub
, git
, perl
, unzip
, makeWrapper
, which
, zlib
}:

with pkgs;

let
  customInstallPhase = ''
    mkdir -p $out/${perl.libPrefix}/${perl.version}/
    tests=$(find modules/ -mindepth 1 -maxdepth 1 -type d | grep -v t)
    cp -r $tests $out/${perl.libPrefix}/${perl.version}/
  '';

  ensemblGit = n: r: s:
    # Copy modules directly
    stdenv.mkDerivation rec {
      name = n;
      version = "110";
      # Neither tag nor release, so we need the commit...
      src = fetchgit {
        url = "https://github.com/Ensembl/${name}";
        rev = r;
        sha256 = s;
      };
      installPhase = customInstallPhase;
    };

  vepPlugins = fetchgit {
    url = "https://github.com/Ensembl/VEP_plugins";
    rev = "8f271c4848338dc7d504881ff71fdf2892c3d096";
    sha256 = "sha256-LbaXwLFDP3m1QhRHwO9uh36BEFHE2NzL4xdxTb7/S5Q=";
  };

  # Install ensembl-xs, faster run using re-implementation in C of some of the Perl subroutines
  ensembl-xs = perlPackages.buildPerlModule rec {
    pname = "ensembl-xs";
    version = "2.3.2";
    src = fetchzip {
      # No longer maintained
      url = "https://github.com/Ensembl/ensembl-xs/archive/2.3.2.zip";
      sha256 = "1qqnski532f4bz32wxbqd9w1sz40rjh81ipp9p02k3rlaf1gp1fa";
    };
    # PREFIX is important
    configurePhase = ''
      perl Makefile.PL PREFIX=$out INSTALLDIRS=site
    '';
    buildPhase = "make";
    # Test do not work -- wrong include path
    checkPhase = "";
    installPhase = "make install";
  };


  # it contains compiled versions of certain key subroutines used in VEP
  ensembl = ensemblGit "ensembl"
    "39154d005fc22b90b57ae2912c7c2838c0801568"
    "sha256-QMRtfAhNdUX3eqo1dva34NSCTmU0X1IrlNmBy4GHgNU=";
  # No release, no tag for these 4 repos
  ensembl-io = ensemblGit "ensembl-io"
    "b1a0d57104ed2532e958194c38159a6092ba8b7b"
    "sha256-IFjEmHXCN1TIaFmcvIPru6vRaz99WtvC2EyBarjw+Vw=";
  ensembl-variation = ensemblGit "ensembl-variation"
    "d34d25e481f22c11705b23a1aded34feb8434010"
    "sha256-UjrLHF9EqI+Mp+SZR4sLNZUCGiA/UYhoFWtpwiKF8tM=";
  ensembl-funcgen = ensemblGit "ensembl-funcgen"
    "24e6da6efd80043cfba810accc4424c812f6a0b0"
    "sha256-a9hxLBoXJsF5JWuRdpyOac1u033M8ivEjEQecuncghs=";

in
perlPackages.buildPerlModule rec {
  inherit (ensembl ensembl-io ensembl-variation ensembl-funcgen ensembl-xs vepPlugins);

  pname = "ensembl-vep";
  version = "110";
  buildInputs = (with perlPackages; [ ArchiveZip BioBigFile BioDBHTS BioExtAlign BioPerl DBI DBDmysql LWP JSON ])
    ++ [
    ensembl-xs
    ensembl
    ensembl-funcgen
    ensembl-io
    ensembl-variation
  ];
  propagatedBuildInputs = [ pkgs.htslib ];
  src = fetchFromGitHub {
    owner = "Ensembl";
    repo = pname;
    rev = "release/110.0";
    sha256 = "sha256-H0F6C+pq+w92uQ0+E3GR2MpOmC41qa+40ORHIsqtvfI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildPhase = "";
  doCheck = false;

  # Cached data.
  # We have tabix, so we only use the indexed version
  cacheURL = "ftp://ftp.ensembl.org/pub/release-${version}/variation/indexed_vep_cache/";
  outputs = [ "out" ];
  postFixup = ''
    wrapProgram $out/bin/vep \
      --add-flags "--dir_plugins ${vepPlugins}";
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp vep filter_vep haplo variant_recoder $out/bin/

    mkdir -p $out/${perl.libPrefix}/${perl.version}/
    cp -r modules/Bio  $out/${perl.libPrefix}/${perl.version}/
    '';

    meta = with lib; {
      homepage = "https://www.ensembl.org/info/docs/tools/vep/index.html";
      description = "Annotate genetics variants based on genes, transcripts, and protein sequence, as well as regulatory regions";
      license = lib.licenses.asl20 ;
      mainProgram = "vep";
      maintainers = with maintainers; [ apraga ];
    };
}
