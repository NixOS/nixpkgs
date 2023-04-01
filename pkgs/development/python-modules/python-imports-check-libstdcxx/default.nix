{ lib
, gcc12Stdenv # The last release
, gcc11Stdenv # Second-to-last, don't forget to bump
, buildPythonPackage
, python3
, callPackage
, psutil
}:

let
  basic = callPackage ./basic.nix { };

  # We could expose just "basic", but we want to hydra to fail if the following
  # sanity checks do not pass:

  loadOld = basic.overridePythonAttrs (a: {
    pname = "${basic.pname}-load-old";
    buildInputs = a.buildInputs ++ [
      gcc11Stdenv.cc.cc.lib
    ];
    nativeBuildInputs = a.nativeBuildInputs ++ [
      gcc11Stdenv.cc
    ];
    cmakeFlags = a.cmakeFlags ++ [
      "-DLOAD_LIBSTDCXX_MODULE_NAME=load_libstdcxx_old"
    ];
    pythonImportsCheck = [
      "load_libstdcxx_old"
    ];
  });

  # The mistake we're trying to avoid is linking things in a way that we can
  # accidentally load an old libstdc++ before we import another python module
  # that needs symbols from a newer libstdc++. We do that by appending
  # load_libstdcxx at the end of pythonImportsCheck: e.g. if after importing
  # tensorflow we spoil the namespace with an old libstdc++, load_libstdcxx
  # should fail.

  # The following derivation verifies that if we first import
  # load_libstdcxx_old and then import load_libstdcxx_new, we do indeed get an
  # ImportError.
  checkFails = basic.overridePythonAttrs (a: {
    pname = "${basic.pname}-check-fails";
    src = lib.sourceFilesBySuffices ./. [ ".txt" ".cc" ".py" ];

    buildInputs = a.buildInputs ++ [
      gcc12Stdenv.cc.cc.lib
    ];
    nativeBuildInputs = a.nativeBuildInputs ++ [
      gcc12Stdenv.cc
    ];

    dontUseCmakeBuildDir = true;
    cmakeFlags = a.cmakeFlags ++ [
      "-DLOAD_LIBSTDCXX_MODULE_NAME=load_libstdcxx_new"
    ];

    nativeCheckInputs = [
      loadOld
      psutil
    ];

    # Verify backward compatibility
    pythonImportsCheck = [
      "load_libstdcxx_new"
      "load_libstdcxx_old"
    ];

    # This variable is read by ./test_forward_compatibility_fails.py 
    EXPECTED_LIBSTDCXX = "${gcc11Stdenv.cc.cc.lib}";

    # Now verify there's no forward compatibility
    preInstallCheck = ''
      ${python3.interpreter} test_forward_compatibility_fails.py
    '';
  });
in
basic.overridePythonAttrs (a: {
  nativeCheckInputs = [
    # Make hydra run checks
    checkFails
  ];

  passthru.tests = { inherit basic loadOld checkFails; };
})
