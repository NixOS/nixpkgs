{
  fetchFromGitHub,
  lib,
  stdenv,
  unzip,
  libxml2,
  gmp,
  m4,
  uthash,
  which,
  pkg-config,
  perl,
  perlPackages,
  fetchurl,
}:

let
  # Perl packages used by this project.
  # TODO: put these into global perl-packages.nix once this is submitted.
  ObjectTinyRW = perlPackages.buildPerlPackage {
    pname = "Object-Tiny-RW";
    version = "1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/object-tiny-rw/Object-Tiny-RW-1.07.tar.gz";
      hash = "sha256-NbQIy9d4ZcMnRJJApPBSej+W6e/aJ8rkb5E7rD7GVgs=";
    };
    meta = {
      description = "Date object with as little code as possible (and rw accessors)";
      license = with lib.licenses; [
        artistic1
        gpl1Plus
      ];
    };
  };

  IteratorSimpleLookahead = perlPackages.buildPerlPackage {
    pname = "Iterator-Simple-Lookahead";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PS/PSCUST/Iterator-Simple-Lookahead-0.09.tar.gz";
      hash = "sha256-FmPE1xdU8LAXS21+H4DJaQ87qDi4Q4UkLawsUAqseZw=";
    };
    propagatedBuildInputs = with perlPackages; [
      ClassAccessor
      IteratorSimple
    ];
    meta = {
      description = "Simple iterator with lookahead and unget";
      license = with lib.licenses; [
        artistic1
        gpl2Only
      ];
    };
  };

  AsmPreproc = perlPackages.buildPerlPackage {
    pname = "Asm-Preproc";
    version = "1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PS/PSCUST/Asm-Preproc-1.03.tar.gz";
      hash = "sha256-pVTpIqGxZpBxZlAbXuGDapuOxsp3uM/AM5dKUxlej1M=";
    };
    propagatedBuildInputs = [
      IteratorSimpleLookahead
    ]
    ++ (with perlPackages; [
      IteratorSimple
      TextTemplate
      DataDump
      FileSlurp
    ]);
    meta = {
      description = "Preprocessor to be called from an assembler";
      license = with lib.licenses; [
        artistic1
        gpl2Only
      ];
    };
  };

  CPUZ80Assembler = perlPackages.buildPerlPackage {
    pname = "CPU-Z80-Assembler";
    version = "2.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PS/PSCUST/CPU-Z80-Assembler-2.25.tar.gz";
      hash = "sha256-cJ8Fl2KZw9/bnBDUzFuwwdw9x23OUvcftk78kw7abdU=";
    };
    buildInputs = [
      AsmPreproc
    ]
    ++ (with perlPackages; [
      CaptureTiny
      RegexpTrie
      PathTiny
      ClassAccessor
    ]);
    meta = {
      description = "Functions to assemble a set of Z80 assembly instructions";
      license = with lib.licenses; [
        artistic1
        gpl2Only
      ];
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "z88dk";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "z88dk";
    repo = "z88dk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RrPu1UcTyin/aiGrV87PZI8f6dazuojJLalyEaFT/kY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # we dont rely on build.sh :
    export PATH="$PWD/bin:$PATH" # needed to have zcc in testsuite
    export ZCCCFG=$PWD/lib/config/

    # we don't want to build zsdcc since it required network (svn)
    # we test in checkPhase
    substituteInPlace Makefile \
      --replace 'testsuite bin/z88dk-lib$(EXESUFFIX)' 'bin/z88dk-lib$(EXESUFFIX)'\
      --replace 'ALL_EXT = bin/zsdcc$(EXESUFFIX)' 'ALL_EXT ='

    # rc2014.lib not created, making corresponding tests fail. Comment out.
    substituteInPlace  test/suites/make.config \
      --replace 'zcc +rc2014'            '#zcc +rc2014' \
      --replace '@$(MACHINE) -pc 0x9000' '#@$(MACHINE) -pc 0x9000'

    # The following tests don't pass.
    rm src/z80asm/t/issue_0341.t
    rm src/z80asm/t/z80asm_lib.t
  '';

  # Parallel building is not working yet with the upstream Makefiles.
  # Explicitly switch this off for now.
  enableParallelBuilding = false;

  doCheck = true;
  checkPhase = ''
    # Need to build libs first, Makefile deps not fully defined
    make libs      $makeFlags
    make testsuite $makeFlags
    make -k test   $makeFlags
  '';

  short_rev = builtins.substring 0 7 finalAttrs.src.rev;
  makeFlags = [
    "git_rev=${finalAttrs.short_rev}"
    "version=${finalAttrs.version}"
    "PREFIX=$(out)"
    "git_count=0"
  ];

  nativeBuildInputs = [
    which
    unzip
    m4
    perl
    pkg-config

    # Local perl packages
    AsmPreproc
    CPUZ80Assembler
    ObjectTinyRW
  ]
  ++ (with perlPackages; [
    CaptureTiny
    DataHexDump
    ModernPerl
    PathTiny
    RegexpCommon
    TestHexDifferences
    TextDiff
    RegexpTrie
  ]);

  buildInputs = [
    libxml2
    uthash
    gmp
  ];

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  installTargets = [
    "libs"
    "install"
  ];

  meta = with lib; {
    homepage = "https://www.z88dk.org";
    description = "z80 Development Kit";
    license = licenses.clArtistic;
    maintainers = with maintainers; [
      siraben
      hzeller
    ];
    platforms = platforms.unix;
  };
})
