{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, installShellFiles
, testers
, yara-x
}:

rustPlatform.buildRustPackage rec {
  pname = "yara-x";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    rev = "refs/tags/v${version}";
    hash = "sha256-xCybcDRswxRHiPf0ultIahxSPqn0YonmR4Kah38wJuw=";
  };

  cargoHash = "sha256-6CDzOxvktJc6AnFOm6OJp3cD2bZ0XCY5HLIoEmP59es=";

  nativeBuildInputs = [ cmake installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd yr \
      --bash <($out/bin/yr completion bash) \
      --fish <($out/bin/yr completion fish) \
      --zsh <($out/bin/yr completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = yara-x;
  };

  meta = {
    description = "Tool to do pattern matching for malware research";
    homepage = "https://virustotal.github.io/yara-x/";
    changelog = "https://github.com/VirusTotal/yara-x/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab lesuisse ];
    mainProgram = "yr";
  };
}
