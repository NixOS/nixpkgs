{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
  testers,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "zprint";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/kkinnear/zprint/releases/download/${finalAttrs.version}/zprint-filter-${finalAttrs.version}";
    sha256 = "sha256-0ogZkC8j+ja0aWvFgNhygof4GZ78aqQA75lRxYfu6do=";
  };

  extraNativeImageBuildArgs = [
    "--no-server"
    "-H:EnableURLProtocols=https,http"
    "-H:+ReportExceptionStackTraces"
    "--report-unsupported-elements-at-runtime"
    "--initialize-at-build-time"
    "--no-fallback"
  ];

  passthru.tests.version = testers.testVersion {
    inherit (finalAttrs) version;
    package = finalAttrs.finalPackage;
    command = "zprint --version";
  };

  meta = {
    description = "Clojure/EDN source code formatter and pretty printer";
    longDescription = ''
      Library and command line tool providing a variety of pretty printing capabilities
      for both Clojure code and Clojure/EDN structures. It can meet almost anyone's needs.
      As such, it supports a number of major source code formatting approaches
    '';
    homepage = "https://github.com/kkinnear/zprint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stelcodes ];
    mainProgram = "zprint";
  };
})
