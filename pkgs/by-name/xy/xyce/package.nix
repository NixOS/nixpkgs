{
  stdenv,
  fetchFromGitHub,
  fetchgit,
  fetchpatch,
  applyPatches,
  lib,
  bison,
  blas,
  cmake,
  flex,
  fftw,
  gfortran,
  lapack,
  libtool_2,
  mpi,
  suitesparse,
  trilinos,
  withMPI ? false,
  # for doc
  texliveMedium,
  enableDocs ? true,
  # for tests
  bash,
  bc,
  openssh, # required by MPI
  perl,
  python3,
  enableTests ? true,
}:

assert withMPI -> trilinos.withMPI;

let
  version = "7.10.0";

  # using fetchurl or fetchFromGitHub doesn't include the manuals
  # due to .gitattributes files
  xyce_src = applyPatches {
    src = fetchgit {
      name = "Xyce";
      url = "https://github.com/Xyce/Xyce.git";
      rev = "Release-${version}";
      hash = "sha256-8cvglBCykZVQk3BD7VE3riXfJ0PAEBwsoloqUsrMlBc=";
    };

    patches = [
      # fix clang build issue
      (fetchpatch {
        url = "https://github.com/Xyce/Xyce/commit/f321f7eb1c59d29fe98054ec02567976aca43120.patch";
        hash = "sha256-VXKMNERrTYciOtb63sIVT36SVsx2scmSWpFE5zaDcX8=";
      })
    ];
  };

  regression_src = applyPatches {
    src = fetchFromGitHub {
      name = "Xyce_Regression";
      owner = "Xyce";
      repo = "Xyce_Regression";
      rev = "Release-${version}";
      hash = "sha256-aA/4UpzSb+EeJ1RVkVwSKiNh7BDcLHxNDnKXZmnCBmI=";
    };
    patches = [
      # remove after next release
      (fetchpatch {
        url = "https://github.com/Xyce/Xyce_Regression/commit/a77e39e409d3ab2ae05d6dcbf08d9e42e3fd0f15.patch";
        hash = "sha256-BJJO2qSwQf+u2HUWhdyBUwP3j4HbMPfXrAhgdzeTZgc=";
      })
    ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "xyce";
  inherit version;

  passthru = {
    inherit xyce_src;
    inherit regression_src;
  };

  srcs = [
    finalAttrs.passthru.xyce_src
    finalAttrs.passthru.regression_src
  ];

  sourceRoot = finalAttrs.passthru.xyce_src.name;

  cmakeFlags = lib.optionals withMPI [
    "-DCMAKE_C_COMPILER=mpicc"
    "-DCMAKE_CXX_COMPILER=mpicxx"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    gfortran
    libtool_2
  ]
  ++ lib.optionals enableDocs [
    (texliveMedium.withPackages (
      ps: with ps; [
        enumitem
        koma-script
        optional
        framed
        multirow
        newtx
        preprint
      ]
    ))
  ];

  buildInputs = [
    bison
    blas
    flex
    fftw
    lapack
    suitesparse
    trilinos
  ]
  ++ lib.optionals withMPI [ mpi ];

  doCheck = enableTests;

  postPatch = ''
    pushd ../${finalAttrs.passthru.regression_src.name}
    find Netlists -type f -regex ".*\.sh\|.*\.pl" -exec chmod ugo+x {} \;
    # some tests generate new files, some overwrite netlists
    find . -type d -exec chmod u+w {} \;
    find . -type f -name "*.cir" -exec chmod u+w {} \;
    patchShebangs Netlists/ TestScripts/
    # patch script generating functions
    sed -i -E 's|/usr/bin/env perl|${lib.escapeRegex perl.outPath}/bin/perl|'  \
      TestScripts/XyceRegression/Testing/Netlists/RunOptions/runOptions.cir.sh
    sed -i -E 's|/bin/sh|${lib.escapeRegex bash.outPath}/bin/sh|' \
      TestScripts/XyceRegression/Testing/Netlists/RunOptions/runOptions.cir.sh
    popd
  '';

  nativeCheckInputs = [
    bc
    perl
    (python3.withPackages (
      ps: with ps; [
        numpy
        scipy
      ]
    ))
  ]
  ++ lib.optionals withMPI [
    mpi
    openssh
  ];

  checkPhase = ''
    XYCE_BINARY="$(pwd)/src/Xyce"
    EXECSTRING="$XYCE_BINARY"
    PARALLEL_TESTS="''${NIX_BUILD_CORES}"
    NP=1
  ''
  + (lib.optionalString withMPI ''
    NP=2
    EXECSTRING="${mpi}/bin/mpirun -np $NP $EXECSTRING"
    PARALLEL_TESTS=$(expr $PARALLEL_TESTS / $NP)
    echo "Running $PARALLEL_TESTS in parallel across $NP MPI processes." > /dev/stderr
  '')
  + ''
    TEST_ROOT="$(pwd)/../../${finalAttrs.passthru.regression_src.name}"

    # Honor the TMP variable
    sed -i -E 's|/tmp|\$TMP|' $TEST_ROOT/TestScripts/suggestXyceTagList.sh

    EXCLUDE_TESTS_FILE=$TMP/exclude_tests.$$
    # Gold standard has additional ":R" suffix in result column label
    echo "Output/HB/hb-step-tecplot.cir" >> $EXCLUDE_TESTS_FILE
    # See dedicated section for this test below
    echo "Certification_Tests/BUG_397/diode.cir" >> $EXCLUDE_TESTS_FILE
    # This test makes Xyce access /sys/class/net when run with MPI
    ${lib.optionalString withMPI "echo \"CommandLine/command_line.cir\" >> $EXCLUDE_TESTS_FILE"}
  ''
  # This test is incompatible with parallel mode and should only be run:
  # 1. if withMPI is false
  # 2. not with run_xyce_regressionMP
  + (lib.optionalString (!withMPI) ''
    $TEST_ROOT/TestScripts/run_xyce_regression \
      "$EXECSTRING" \
      --output="$(pwd)/Xyce_Test" \
      --xyce_test="$TEST_ROOT" \
      --onetest="Certification_Tests/BUG_397/diode.cir" \
      --resultfile="$(pwd)/diode_test_results"
  '')
  + ''
    $TEST_ROOT/TestScripts/run_xyce_regressionMP \
      "$EXECSTRING" \
      --output="$(pwd)/Xyce_Test" \
      --xyce_test="$TEST_ROOT" \
      --taglist="$($TEST_ROOT/TestScripts/suggestXyceTagList.sh "$XYCE_BINARY" | sed -E -e 's/TAGLIST=([^ ]+).*/\1/' -e '2,$d')" \
      --resultfile="$(pwd)/test_results" \
      --excludelist="$EXCLUDE_TESTS_FILE" \
      --numproc="$PARALLEL_TESTS"
  '';

  outputs = [
    "out"
    "doc"
  ];

  postInstall = lib.optionalString enableDocs ''
    pushd ../../${finalAttrs.passthru.xyce_src.name}

    VER_MAJOR_MINOR=${lib.versions.majorMinor finalAttrs.version}

    local docFiles=("doc/Users_Guide/Xyce_UG"
      "doc/Reference_Guide/Xyce_RG"
      "doc/Release_Notes/Release_Notes_''$VER_MAJOR_MINOR/Release_Notes_''$VER_MAJOR_MINOR")
    # hotfix for: https://github.com/Xyce/Xyce/issues/177
    substituteInPlace doc/Reference_Guide/Xyce_RG_macros.tex \
      --replace-fail "\\def\\device{\\goodbreak" "\\def\\device{\\item[]\\goodbreak"

    # SANDIA LaTeX class and some organization logos are not publicly available see
    # https://groups.google.com/g/xyce-users/c/MxeViRo8CT4/m/ppCY7ePLEAAJ
    for img in "snllineblubrd" "snllineblk" "DOEbwlogo" "NNSA_logo"; do
      sed -i -E "s/\\includegraphics\[height=(0.[1-9]in)\]\{$img\}/\\mbox\{\\\\rule\{0mm\}\{\1\}\}/" ''${docFiles[2]}.tex
    done

    install -d $doc/share/doc/xyce-${finalAttrs.version}/
    for d in ''${docFiles[@]}; do
      # Use a public document class
      sed -i -E 's/\\documentclass\[11pt,report\]\{SANDreport\}/\\documentclass\[11pt,letterpaper\]\{scrreprt\}/' $d.tex
      sed -i -E 's/\\usepackage\[sand\]\{optional\}/\\usepackage\[report\]\{optional\}/' $d.tex
      sed -i -E 's/\\SANDauthor/\\author/' $d.tex
      pushd $(dirname $d)
      make
      install -t $doc/share/doc/xyce-${finalAttrs.version}/ $(basename $d.pdf)
      popd
    done
    popd
  '';

  meta = {
    description = "High-performance analog circuit simulator";
    longDescription = ''
      Xyce is a SPICE-compatible, high-performance analog circuit simulator,
      capable of solving extremely large circuit problems by supporting
      large-scale parallel computing platforms.
    '';
    homepage = "https://xyce.sandia.gov";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    badPlatforms = lib.optionals withMPI [
      "aarch64-darwin" # segfaults when running tests and reports no valid Xyce executable
      "aarch64-linux" # reports no valid Xyce executable
    ];
  };
})
