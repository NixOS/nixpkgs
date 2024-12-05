{
  lib,
  stdenv,
  adaptivecpp,
  # after cursory testing it seems like this isn't really useful, but if errors pop up, maybe look into restricting the targets
  targetsBuild ? null,
  targetsRun ? null,
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
