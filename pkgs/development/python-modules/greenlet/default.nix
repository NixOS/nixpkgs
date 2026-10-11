{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # tests
  objgraph,
  psutil,
  python,
  unittestCheckHook,
}:

let
  greenlet = buildPythonPackage (finalAttrs: {
    pname = "greenlet";
    version = "3.5.5";
    pyproject = true;

    src = fetchPypi {
      pname = "greenlet";
      inherit (finalAttrs) version;
      hash = "sha256-rbS64C6RqOhj5IsXfkAUvcrIprXgR+od9oemFTS4Xmw=";
    };

    build-system = [ setuptools ];

    # tests in passthru, infinite recursion via objgraph/graphviz
    doCheck = false;

    nativeCheckInputs = [
      objgraph
      psutil
      unittestCheckHook
    ];

    # https://github.com/python-greenlet/greenlet/issues/395
    env.NIX_CFLAGS_COMPILE = lib.optionalString (
      stdenv.hostPlatform.isPower64 || stdenv.hostPlatform.isLoongArch64
    ) "-fomit-frame-pointer";

    preCheck = ''
      pushd ${placeholder "out"}/${python.sitePackages}
    '';

    unittestFlags = [ "--start-directory=greenlet.tests" ];

    postCheck = ''
      popd
    '';

    passthru.tests.pytest = greenlet.overridePythonAttrs (_: {
      doCheck = true;
    });

    meta = {
      changelog = "https://github.com/python-greenlet/greenlet/blob/${finalAttrs.version}/CHANGES.rst";
      homepage = "https://github.com/python-greenlet/greenlet";
      description = "Module for lightweight in-process concurrent programming";
      license = with lib.licenses; [
        psfl # src/greenlet/slp_platformselect.h & files in src/greenlet/platform/ directory
        mit
      ];
    };
  });
in
greenlet
