{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "exfat-raw";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MBanucu";
    repo = "exfat-raw";
    rev = "v${version}";
    hash = "sha256-/blT0neRmfgApHk2mVknOrC2feolhU9u8pz232TIfdg=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = true;
  pythonImportsCheck = [ "exfat_raw" ];

  # Integration tests require sudo (losetup + mount) and are skipped
  # in the Nix sandbox. Only sandbox-safe image-based tests are run.
  checkPhase = ''
    runHook preCheck
    python -m unittest discover -s tests -p 'test_exfat_raw_image.py' -v
    runHook postCheck
  '';

  meta = with lib; {
    description = "Raw block-level read/write of exFAT filesystem timestamps (birth time, modification time)";
    homepage = "https://github.com/MBanucu/exfat-raw";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbanucu ];
  };
}
