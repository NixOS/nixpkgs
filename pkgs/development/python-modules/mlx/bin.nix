{
  buildPythonPackage,
  fetchPypi,
  lib,
  mlx-metal,
  python,
  runCommand,
  stdenv,
}:

let
  version = "0.31.2";
  inherit (python) pythonVersion;

  getSrcFromPypi =
    {
      platform,
      dist,
      hash,
    }:
    fetchPypi {
      pname = "mlx";
      inherit
        version
        platform
        dist
        hash
        ;
      format = "wheel";
      python = dist;
      abi = dist;
    };

  srcs = {
    "3.13-aarch64-darwin" = getSrcFromPypi {
      platform = "macosx_14_0_arm64";
      dist = "cp313";
      hash = "sha256-Gz+w3alVsNVSzle91vQrMwmrIbBn5AWH1oSEQ9MH6R8=";
    };
    "3.14-aarch64-darwin" = getSrcFromPypi {
      platform = "macosx_14_0_arm64";
      dist = "cp314";
      hash = "sha256-oTyc4jw97vaqWgkxXnlT4aXcMR6FH6Fvx0yB+yUJwLk=";
    };
  };
in
buildPythonPackage (finalAttrs: {
  pname = "mlx";
  inherit version;
  format = "wheel";
  __structuredAttrs = true;

  disabled = !(srcs ? "${pythonVersion}-${stdenv.hostPlatform.system}");

  src =
    srcs."${pythonVersion}-${stdenv.hostPlatform.system}"
      or (throw "mlx-bin is only supported on Python ${builtins.concatStringsSep ", " (builtins.attrNames srcs)}");

  dependencies = [ mlx-metal ];

  postInstall = ''
    # The Python wheel expects libmlx.dylib and mlx.metallib to live under
    # mlx/lib next to the extension module, but those files are shipped by the
    # separate mlx-metal wheel.
    ln -s ${mlx-metal}/${python.sitePackages}/mlx/lib $out/${python.sitePackages}/mlx/lib
  '';

  pythonImportsCheck = [ "mlx" ];

  passthru.tests.linkedMetalRuntime =
    runCommand "python${python.pythonVersion}-mlx-bin-linked-metal-runtime" { }
      ''
        test -L ${finalAttrs.finalPackage}/${python.sitePackages}/mlx/lib
        test -e ${finalAttrs.finalPackage}/${python.sitePackages}/mlx/lib/libmlx.dylib
        test -e ${finalAttrs.finalPackage}/${python.sitePackages}/mlx/lib/mlx.metallib
        touch $out
      '';

  meta = {
    description = "Prebuilt MLX wheel for Apple silicon with Metal runtime";
    homepage = "https://github.com/ml-explore/mlx";
    changelog = "https://github.com/ml-explore/mlx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kinnrai ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "aarch64-darwin" ];
  };
})
