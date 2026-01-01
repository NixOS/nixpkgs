{
  stdenv,
  fetchFromGitHub,
  fetchgit,
  lib,
<<<<<<< HEAD
  bison,
  blas,
  cmake,
=======
  autoconf,
  automake,
  bison,
  blas,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "7.10.0";
=======
  version = "7.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # using fetchurl or fetchFromGitHub doesn't include the manuals
  # due to .gitattributes files
  xyce_src = fetchgit {
<<<<<<< HEAD
    name = "Xyce";
    url = "https://github.com/Xyce/Xyce.git";
    rev = "Release-${version}";
    hash = "sha256-8cvglBCykZVQk3BD7VE3riXfJ0PAEBwsoloqUsrMlBc=";
  };

  regression_src = fetchFromGitHub {
    name = "Xyce_Regression";
    owner = "Xyce";
    repo = "Xyce_Regression";
    rev = "Release-${version}";
    hash = "sha256-aA/4UpzSb+EeJ1RVkVwSKiNh7BDcLHxNDnKXZmnCBmI=";
=======
    url = "https://github.com/Xyce/Xyce.git";
    rev = "Release-${version}";
    sha256 = "sha256-m8tHQYBs0hjepTDswrDJFRCPY941Ew98gYRPuQMdKZA=";
  };

  regression_src = fetchFromGitHub {
    owner = "Xyce";
    repo = "Xyce_Regression";
    rev = "Release-${version}";
    sha256 = "sha256-7Jvt2LUw2C201pMp9CHnhOwMzxU7imfrRKCb3wu3Okk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in

stdenv.mkDerivation rec {
  pname = "xyce";
  inherit version;

  srcs = [
    xyce_src
    regression_src
  ];

  sourceRoot = xyce_src.name;

<<<<<<< HEAD
  cmakeFlags = lib.optionals withMPI [
    "-DCMAKE_C_COMPILER=mpicc"
    "-DCMAKE_CXX_COMPILER=mpicxx"
=======
  preConfigure = "./bootstrap";

  configureFlags = [
    "CXXFLAGS=-O3"
    "--enable-xyce-shareable"
    "--enable-shared"
    "--enable-stokhos"
    "--enable-amesos2"
  ]
  ++ lib.optionals withMPI [
    "--enable-mpi"
    "CXX=mpicxx"
    "CC=mpicc"
    "F77=mpif77"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
<<<<<<< HEAD
    cmake
=======
    autoconf
    automake
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
        enumitem
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
    pushd ../${regression_src.name}
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
    EXECSTRING="${lib.optionalString withMPI "mpirun -np 2 "}$XYCE_BINARY"
<<<<<<< HEAD
    TEST_ROOT="$(pwd)/../../${regression_src.name}"
=======
    TEST_ROOT="$(pwd)/../${regression_src.name}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    # Honor the TMP variable
    sed -i -E 's|/tmp|\$TMP|' $TEST_ROOT/TestScripts/suggestXyceTagList.sh

    EXCLUDE_TESTS_FILE=$TMP/exclude_tests.$$
    # Gold standard has additional ":R" suffix in result column label
    echo "Output/HB/hb-step-tecplot.cir" >> $EXCLUDE_TESTS_FILE
    # This test makes Xyce access /sys/class/net when run with MPI
    ${lib.optionalString withMPI "echo \"CommandLine/command_line.cir\" >> $EXCLUDE_TESTS_FILE"}

    $TEST_ROOT/TestScripts/run_xyce_regression \
      --output="$(pwd)/Xyce_Test" \
      --xyce_test="''${TEST_ROOT}" \
      --taglist="$($TEST_ROOT/TestScripts/suggestXyceTagList.sh "$XYCE_BINARY" | sed -E -e 's/TAGLIST=([^ ]+).*/\1/' -e '2,$d')" \
      --resultfile="$(pwd)/test_results" \
      --excludelist="$EXCLUDE_TESTS_FILE" \
      "''${EXECSTRING}"
  '';

  outputs = [
    "out"
    "doc"
  ];

  postInstall = lib.optionalString enableDocs ''
<<<<<<< HEAD
    pushd ../../${xyce_src.name}
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    local docFiles=("doc/Users_Guide/Xyce_UG"
      "doc/Reference_Guide/Xyce_RG"
      "doc/Release_Notes/Release_Notes_${lib.versions.majorMinor version}/Release_Notes_${lib.versions.majorMinor version}")

    # SANDIA LaTeX class and some organization logos are not publicly available see
    # https://groups.google.com/g/xyce-users/c/MxeViRo8CT4/m/ppCY7ePLEAAJ
    for img in "snllineblubrd" "snllineblk" "DOEbwlogo" "NNSA_logo"; do
      sed -i -E "s/\\includegraphics\[height=(0.[1-9]in)\]\{$img\}/\\mbox\{\\rule\{0mm\}\{\1\}\}/" ''${docFiles[2]}.tex
    done

    install -d $doc/share/doc/${pname}-${version}/
    for d in ''${docFiles[@]}; do
      # Use a public document class
      sed -i -E 's/\\documentclass\[11pt,report\]\{SANDreport\}/\\documentclass\[11pt,letterpaper\]\{scrreprt\}/' $d.tex
      sed -i -E 's/\\usepackage\[sand\]\{optional\}/\\usepackage\[report\]\{optional\}/' $d.tex
      sed -i -E 's/\\SANDauthor/\\author/' $d.tex
      pushd $(dirname $d)
      make
      install -t $doc/share/doc/${pname}-${version}/ $(basename $d.pdf)
      popd
    done
<<<<<<< HEAD
    popd
  '';

  meta = {
=======
  '';

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken =
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    description = "High-performance analog circuit simulator";
    longDescription = ''
      Xyce is a SPICE-compatible, high-performance analog circuit simulator,
      capable of solving extremely large circuit problems by supporting
      large-scale parallel computing platforms.
    '';
    homepage = "https://xyce.sandia.gov";
<<<<<<< HEAD
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ fbeffa ];
=======
    license = licenses.gpl3;
    maintainers = with maintainers; [ fbeffa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
  };
}
