{
  enableGStreamer,
  enableGtk2,
  enableGtk3,
  gst_all_1,
  lib,
  opencv4,
  runAccuracyTests,
  runCommand,
  runPerformanceTests,
  stdenv,
  testDataSrc,
  writableTmpDirAsHomeHook,
  xvfb-run,
}:
let
  inherit (lib) getExe optionals optionalString;
  inherit (opencv4.passthru) cudaSupport;
  inherit (stdenv.hostPlatform) isAarch64 isDarwin;
in
runCommand "opencv4-tests"
  {
    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      writableTmpDirAsHomeHook
    ]
    ++ optionals enableGStreamer (
      with gst_all_1;
      [
        gstreamer
        gst-plugins-base
        gst-plugins-good
      ]
    );

    ignoredTests = [
      "AsyncAPICancelation/cancel*"
      "Photo_CalibrateDebevec.regression"
    ]
    ++ optionals cudaSupport [
      # opencv4-tests> /build/source/modules/photo/test/test_denoising.cuda.cpp:115: Failure
      # opencv4-tests> The max difference between matrices "bgr_gold" and "dbgr" is 2 at (339, 486), which exceeds "1", where "bgr_gold" at (339, 486) evaluates to (182, 239, 239), "dbgr" at (339, 486) evaluates to (184, 239, 239), "1" evaluates to 1
      # opencv4-tests> [  FAILED  ] CUDA_FastNonLocalMeans.Regression (48 ms)
      "CUDA_FastNonLocalMeans.Regression"
    ];

    inherit runAccuracyTests;

    accuracyTestNames = [
      # "calib3d" # reached a month of CPU time without completing
      "core"
      "features2d"
      "flann"
      "imgcodecs"
      "imgproc"
      "ml"
      "objdetect"
      "photo"
      "stitching"
      "video"
      #"videoio" # - a lot of GStreamer warnings and failed tests
      #"dnn" #- some caffe tests failed, probably because github workflow also downloads additional models
    ]
    ++ optionals (!isAarch64 && enableGStreamer) [ "gapi" ]
    ++ optionals (enableGtk2 || enableGtk3) [ "highgui" ];

    inherit runPerformanceTests;

    performanceTestNames = [
      # "calib3d" # reached a month of CPU time without completing
      "core"
      "features2d"
      "imgcodecs"
      "imgproc"
      "objdetect"
      "photo"
      "stitching"
      "video"
    ]
    ++ optionals (!isAarch64 && enableGStreamer) [ "gapi" ];

    testRunner = optionalString (!isDarwin) "${getExe xvfb-run} -a ";

    requiredSystemFeatures = [ "big-parallel" ] ++ optionals cudaSupport [ "cuda" ];
  }
  ''
    set -euo pipefail

    # several tests want a write access, so we have to copy files
    nixLog "Preparing test data"
    cp -R "${testDataSrc}" "$HOME/opencv_extra"
    chmod -R +w "$HOME/opencv_extra"
    export OPENCV_TEST_DATA_PATH="$HOME/opencv_extra/testdata"
    export OPENCV_SAMPLES_DATA_PATH="${opencv4.package_tests}/samples/data"

    # ignored tests because of gtest error - "Test code is not available due to compilation error with GCC 11"
    # ignore test due to numerical instability
    if [[ -n ''${ignoredTests+x} ]]; then
      export GTEST_FILTER="-$(concatStringsSep ":" ignoredTests)"
      nixLog "Using GTEST_FILTER: $GTEST_FILTER"
    fi

    if [[ -n $runAccuracyTests ]]; then
      nixLog "Running accuracy tests"
      for testName in "''${accuracyTestNames[@]}"; do
        nixLog "Running accuracy test: $testName"
        ''${testRunner}${opencv4.package_tests}/opencv_test_''${testName} \
          --test_threads=$NIX_BUILD_CORES
      done
      nixLog "Finished running accuracy tests"
    fi

    if [[ -n $runPerformanceTests ]]; then
      nixLog "Running performance tests"
      for testName in "''${performanceTestNames[@]}"; do
        nixLog "Running performance test: $testName"
        ''${testRunner}${opencv4.package_tests}/opencv_perf_''${testName} \
          --perf_impl=plain \
          --perf_min_samples=10 \
          --perf_force_samples=10 \
          --perf_verify_sanity \
          --skip_unstable=1
      done
      nixLog "Finished running performance tests"
    fi

    nixLog "Finished running tests"
    touch "$out"
  ''
