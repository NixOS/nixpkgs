{
  buildPythonPackage,
  lib,
  rustPlatform,
  stdenv,
  attrs,
  darwin,
  numpy,
  pillow,
  pyarrow,
  rerun,
  torch,
  typing-extensions,
  pytestCheckHook,
  python,
  libiconv,
}:

buildPythonPackage {
  pname = "rerun-sdk";
  inherit (rerun) version;
  pyproject = true;

  inherit (rerun) src;
  inherit (rerun) cargoDeps;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs =
    [
      libiconv # No-op on Linux, necessary on Darwin.
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreServices
    ];

  propagatedBuildInputs = [
    attrs
    numpy
    pillow
    pyarrow
    typing-extensions
  ];

  buildAndTestSubdir = "rerun_py";

  # https://github.com/NixOS/nixpkgs/issues/289340
  #
  # Alternatively, one could
  # dontUsePythonImportsCheck = true;
  # dontUsePytestCheck = true;
  postInstall = ''
    rm $out/${python.sitePackages}/rerun_sdk.pth
    ln -s rerun_sdk/rerun $out/${python.sitePackages}/rerun
  '';

  pythonImportsCheck = [ "rerun" ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  inherit (rerun) addDlopenRunpaths addDlopenRunpathsPhase;
  postPhases = lib.optionals stdenv.isLinux [ "addDlopenRunpathsPhase" ];

  disabledTestPaths = [
    # "fixture 'benchmark' not found"
    "tests/python/log_benchmark/test_log_benchmark.py"
  ];

  meta = {
    description = "Python bindings for `rerun` (an interactive visualization tool for stream data)";
    inherit (rerun.meta)
      changelog
      homepage
      license
      maintainers
      ;
    mainProgram = "rerun";
  };
}
