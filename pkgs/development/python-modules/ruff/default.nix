{ lib
, buildPythonPackage
, pythonOlder
, rustPlatform
, stdenv
, darwin
, fetchFromGitHub
, installShellFiles
}:

buildPythonPackage rec {
  pname = "ruff";
  version = "0.0.244";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oQBNVs7hoiXNqz5lYq5YNKHfpQ/c8LZAvNvtFqpTM2E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-61kypAXWfUZLfTbSp+b0gCKwuWtxAYVtKIwfVOcJ2o8=";
  };

  nativeBuildInputs = [
    installShellFiles
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  postInstall = ''
    installShellCompletion --cmd ruff \
      --bash <($out/bin/ruff generate-shell-completion bash) \
      --fish <($out/bin/ruff generate-shell-completion fish) \
      --zsh <($out/bin/ruff generate-shell-completion zsh)
  '';

  meta = with lib; {
    description = "Python library wrapping ruff, an extremely fast Python linter";
    homepage = "https://github.com/charliermarsh/ruff";
    changelog = "https://github.com/charliermarsh/ruff/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ruby0b ];
  };
}
