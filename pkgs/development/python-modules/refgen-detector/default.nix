{
  fetchFromGitHub,
  pkgs,
  buildPythonPackage,
  setuptools,
  wheel,
  pysam,
  pandas,
  rich,
  dnspython,
  msgpack,
  psutil,
  python,
  lib,
  ...
}:

buildPythonPackage (finalAttrs: {
  pname = "refgenDetector";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "EGA-archive";
    repo = "refgenDetector";
    rev = "ea0d833e1d667c846e1cb985eedfbc79be558740"; # V3.0.6 but not tag yet
    hash = "sha256-Wa+rk6XxWlYgYFDXz/ygABYl6unvtFJ8g7Va/D/CRF8=";
  };

  format = "setuptools";

  nativeBuildInputs = [ pkgs.xz ];

  preBuild = ''
    rm -rf bin dist build *.egg-info
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    pysam
    pandas
    rich
    dnspython
    msgpack
    psutil
  ];

  postInstall = ''
    runHook preInstall
    mkdir -p $out/${python.sitePackages}/refgenDetector/msgpacks
    for f in src/refgenDetector/github_msgpacks/*.xz; do
      echo "unpacking $f"
      xz -dc "$f" > "$out/${python.sitePackages}/refgenDetector/msgpacks/$(basename "$f" .xz)"
    done
  '';

  pythonImportsCheck = [ "refgenDetector" ];

  checkPhase = ''
    runHook preCheck

    $out/bin/refgenDetector -h > /dev/null

    runHook postCheck
  '';

  meta = {
    description = "EGA - RefgenDetector";
    homepage = "https://github.com/EGA-archive/refgenDetector";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rub-br ];
  };
})
