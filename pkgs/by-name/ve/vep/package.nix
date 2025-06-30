# Instructions:http://www.ensembl.org/info/docs/api/api_installation.html,
# Do not use https://github.com/Ensembl/ensembl-vep/archive/release/${version}.zip
# We cannot use INSTALL.pl but it’s not that bad:install the dependencies and copies the .pm files should be ok
{
  lib,
  htslib,
  perlPackages,
  stdenv,
  fetchFromGitHub,
  perl,
  makeWrapper,
}:

let
  version = "110";
  customInstallPhase = ''
    mkdir -p $out/${perl.libPrefix}/${perl.version}/
    tests=$(find modules/ -mindepth 1 -maxdepth 1 -type d | grep -v t)
    cp -r $tests $out/${perl.libPrefix}/${perl.version}/
  '';

  ensemblGit =
    name: sha256:
    # Copy modules directly
    stdenv.mkDerivation {
      inherit name version;
      src = fetchFromGitHub {
        inherit sha256 version;
        owner = "Ensembl";
        repo = name;
        rev = "release/${version}";
      };
      installPhase = ''
        runHook preInstall

        ${customInstallPhase}

        runHook postInstall'';
    };

  vepPlugins = fetchFromGitHub {
    owner = "Ensembl";
    repo = "VEP_plugins";
    rev = "8f271c4848338dc7d504881ff71fdf2892c3d096";
    sha256 = "sha256-LbaXwLFDP3m1QhRHwO9uh36BEFHE2NzL4xdxTb7/S5Q=";
  };

  # Install ensembl-xs, faster run using re-implementation in C of some of the Perl subroutines
  ensembl-xs = perlPackages.buildPerlPackage rec {
    pname = "ensembl-xs";
    version = "2.3.2";
    src = fetchFromGitHub {
      inherit version;
      owner = "Ensembl";
      repo = "ensembl-xs";
      rev = version;
      sha256 = "1qqnski532f4bz32wxbqd9w1sz40rjh81ipp9p02k3rlaf1gp1fa";
    };
    # PREFIX is important
    configurePhase = ''
      perl Makefile.PL PREFIX=$out INSTALLDIRS=site
    '';
    # Test do not work -- wrong include path
    doCheck = false;
  };

  # it contains compiled versions of certain key subroutines used in VEP
  ensembl = ensemblGit "ensembl" "sha256-ZhI4VNxIY+53RX2uYRNlFeo/ydAmlwGx00WDXaxv6h4=";
  ensembl-io = ensemblGit "ensembl-io" "sha256-r3RvN5U2kcyghoKM0XuiBRe54t1U4FaZ0QEeYIFiG0w=";
  ensembl-variation = ensemblGit "ensembl-variation" "sha256-UjrLHF9EqI+Mp+SZR4sLNZUCGiA/UYhoFWtpwiKF8tM=";
  ensembl-funcgen = ensemblGit "ensembl-funcgen" "sha256-a9hxLBoXJsF5JWuRdpyOac1u033M8ivEjEQecuncghs=";
in
perlPackages.buildPerlModule rec {
  inherit version;
  pname = "vep";
  buildInputs =
    (with perlPackages; [
      ArchiveZip
      BioBigFile
      BioDBHTS
      BioExtAlign
      BioPerl
      DBI
      DBDmysql
      LWP
      JSON
    ])
    ++ [
      ensembl-xs
      ensembl
      ensembl-funcgen
      ensembl-io
      ensembl-variation
    ];
  propagatedBuildInputs = [ htslib ];
  src = fetchFromGitHub {
    owner = "Ensembl";
    repo = "ensembl-${pname}";
    rev = "release/${version}";
    sha256 = "sha256-6lRdWV2ispl+mpBhkZez/d9PxOw1fkNUWeG8mUIqBJc=";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;
  doCheck = false;

  outputs = [ "out" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D -m755 filter_vep vep $out/bin/

    wrapProgram $out/bin/vep \
      --prefix PERL5LIB : $out/${perl.libPrefix}/${perl.version}/ \
      --add-flags "--dir_plugins ${vepPlugins}"

    wrapProgram $out/bin/filter_vep \
      --prefix PERL5LIB : $out/${perl.libPrefix}/${perl.version}/
    ${customInstallPhase}

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.ensembl.org/info/docs/tools/vep/index.html";
    description = "Annotate genetics variants based on genes, transcripts, and protein sequence, as well as regulatory regions";
    license = lib.licenses.asl20;
    mainProgram = "vep";
    maintainers = with lib.maintainers; [ apraga ];
    platforms = lib.platforms.unix;
  };
}
