{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  udisks2,
}:

buildPythonPackage rec {
  pname = "exfat-raw";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MBanucu";
    repo = "exfat-raw";
    rev = "v${version}";
    hash = "sha256-nmWMmU6GNnb2vi9ebC0brpCfyFdBICdAraOqhspesng=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = true;
  pythonImportsCheck = [ "exfat_raw" ];

  # Integration tests require sudo (losetup + mount).
  # In the Nix build sandbox sudo is not available, so tests are skipped.
  checkPhase = ''
    runHook preCheck
    if command -v sudo >/dev/null 2>&1; then
      python -m unittest discover -s tests -v
    else
      echo "sudo not available (sandbox) — skipping integration tests"
    fi
    runHook postCheck
  '';

  meta = with lib; {
    description = "Raw block-level read/write of exFAT filesystem timestamps (birth time, modification time)";
    homepage = "https://github.com/MBanucu/exfat-raw";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbanucu ];
  };
}
