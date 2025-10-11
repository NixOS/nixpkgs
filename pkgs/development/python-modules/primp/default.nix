{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytest,
  gcc-unwrapped,
  python,
  boringssl,
  runCommand,
}:

let
  # boring-sys expects the static libraries in build/ instead of lib/
  boringssl-wrapper = runCommand "boringssl-wrapper" { } ''
    mkdir $out
    ln -s ${boringssl.out}/lib $out/build
    ln -s ${boringssl.dev}/include $out/include
  '';
in
buildPythonPackage rec {
  pname = "primp";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "primp";
    tag = "v${version}";
    hash = "sha256-13o0Ni0dvZaoKgYy2cFQhebwKAJGm5Z2s+gVAddxYxU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-UBpf9f3wJgbizHERsm83cuKHiMixj/8JX/IGvteySIo=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  # TODO: Can we improve this?
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.getLib gcc-unwrapped.lib} --add-needed libstdc++.so.6 $out/${python.sitePackages}/primp/primp.abi3.so
  '';

  env.BORING_BSSL_PATH = boringssl-wrapper;
  env.BORING_BSSL_ASSUME_PATCHED = true;

  optional-dependencies = {
    dev = [ pytest ];
  };

  # Test use network
  doCheck = false;

  pythonImportsCheck = [ "primp" ];

  meta = {
    changelog = "https://github.com/deedy5/primp/releases/tag/${version}";
    description = "Python Requests IMPersonate, the fastest Python HTTP client that can impersonate web browsers";
    homepage = "https://github.com/deedy5/primp";
    license = lib.licenses.mit;
    maintainers = [ ];
    # The boring-ssl crate requires a specifically patched 2yo version version of boringssl (unsecure)
    # Upstream does not seem to have any update plan for this dependency
    # https://github.com/0x676e67/boring2/issues/90
    # broken = true;
  };
}
