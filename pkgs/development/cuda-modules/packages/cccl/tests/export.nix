{
  backendStdenv,
  cccl,
  cmake,
}:
# Runs upstream's test of the installed CMake packages: each package must be found with find_package, and its version
# must match the version macro in its headers.
backendStdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;

  name = "${cccl.name}-export-test";

  inherit (cccl) src;

  sourceRoot = "${cccl.src.name}/test/cmake/test_export";

  nativeBuildInputs = [ cmake ];

  dontConfigure = true;

  packagesToFind = [
    "CCCL DEFAULT"
    "CCCL Thrust"
    "CCCL CUB"
    "CCCL libcudacxx"
    "NATIVE Thrust"
    "NATIVE CUB"
    "NATIVE libcudacxx"
  ];

  buildPhase = ''
    runHook preBuild

    for packageToFind in "''${packagesToFind[@]}"; do
      read -r packageType components <<<"$packageToFind"
      nixLog "finding $components through the $packageType package"
      buildDir="build-$packageType-$components"
      cmake -S . -B "$buildDir" \
        -DCCCL_ROOT=${cccl} \
        -DROOT_TYPE=INSTALL \
        -DPACKAGE_TYPE="$packageType" \
        -DCOMPONENTS="$components"
      cmake --build "$buildDir"
      ctest --test-dir "$buildDir" --output-on-failure
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    touch "$out"
    runHook postInstall
  '';
}
