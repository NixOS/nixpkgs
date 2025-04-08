{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  mitmproxy,
  mitmproxy-linux,
  mitmproxy-macos,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "mitmproxy-rs";
  version = "0.11.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = "v${version}";
    hash = "sha256-vC+Vsv7UWjkO+6lm7gAb91Ig04Y7r9gYQoz6R9xpxsA=";
  };

  buildAndTestSubdir = "mitmproxy-rs";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-CFsefq1zQLIYjZcfoy3afYfP/0MlBoi9kVx7FVGEKr0=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies =
    lib.optionals stdenv.hostPlatform.isLinux [ mitmproxy-linux ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ mitmproxy-macos ];
  # not packaged yet
  # ++ lib.optionals stdenv.hostPlatform.isWindows [ mitmproxy-windows ]

  # repo has no python tests
  doCheck = false;

  pythonImportsCheck = [ "mitmproxy_rs" ];

  meta = with lib; {
    description = "Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = licenses.mit;
    inherit (mitmproxy.meta) maintainers;
  };
}
