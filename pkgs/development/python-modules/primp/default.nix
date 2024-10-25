{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytest,
  runCommand,
  boringssl,
  libiconv,
  SystemConfiguration,
  patchelf,
  gcc-unwrapped,
  python,
}:

let
  # boring-sys expects the static libraries in build/ instead of lib/
  boringssl-wrapper = runCommand "boringssl-wrapper" { } ''
    mkdir $out
    cd $out
    ln -s ${boringssl.out}/lib build
    ln -s ${boringssl.dev}/include include
  '';
in
buildPythonPackage rec {
  pname = "primp";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "primp";
    rev = "refs/tags/v${version}";
    hash = "sha256-wCD99eEU4RW8kUJY72cXhJh5124PVd6kJt+HZjm/hFI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-iY6TSc7GU6OWVUpW6qpwH4g9/eGKhP/YZ5PQoO8NmVc=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  # TODO: Can we improve this?
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    ${lib.getExe patchelf} --add-rpath ${lib.getLib gcc-unwrapped.lib} --add-needed libstdc++.so.6 $out/${python.sitePackages}/primp/primp.abi3.so
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    SystemConfiguration
  ];

  env.BORING_BSSL_PATH = boringssl-wrapper;

  optional-dependencies = {
    dev = [ pytest ];
  };

  # Test use network
  doCheck = false;

  pythonImportsCheck = [ "primp" ];

  meta = {
    changelog = "https://github.com/deedy5/primp/releases/tag/${version}";
    description = "PRIMP (Python Requests IMPersonate). The fastest python HTTP client that can impersonate web browsers.";
    homepage = "https://github.com/deedy5/primp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
