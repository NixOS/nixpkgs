{
  lib,
  stdenv,
  adaptivecpp,
  # within the nix sandbox, the tests will likely be unable to access the gpu.
  # for now we just test omp by default as a sanity check,
  # however the bulk of work in acpp focuses on the generic target, so we want to switch to that.
  targetsBuild ? "omp",
  targetsRun ? "omp",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "${adaptivecpp.pname}-tests";
  inherit (adaptivecpp)
    version
    src
    nativeBuildInputs
    buildInputs
    ;

  sourceRoot = "${adaptivecpp.src.name}/tests";

  cmakeFlags =
    [
      # see above
      "-DAdaptiveCpp_DIR=${adaptivecpp}/lib/cmake/AdaptiveCpp"
    ]
    ++ lib.optionals (targetsBuild != null) [
      "-DACCP_TARGETS=\"${targetsBuild}\""
    ];

  doCheck = true;
  checkPhase = ''
    # the test runner wants to write to $HOME/.acpp, so we need to have it point to a real directory
    mkdir home
    export HOME=`pwd`/home

    ${lib.strings.optionalString (targetsRun != null) "export ACPP_VISIBILITY_MASK=\"${targetsRun}\""}
    ./sycl_tests
  '';

  installPhase = "touch $out";
})
