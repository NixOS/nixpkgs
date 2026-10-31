{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pysam,
  pandas,
  rich,
  dnspython,
  msgpack,
  psutil,
  python,
  lib,
  xz,
}:

buildPythonPackage (finalAttrs: {
  pname = "refgenDetector";
  version = "3.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EGA-archive";
    repo = "refgenDetector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4mywVm+iF5yaaWI6Liv1ilz5ZhBoI6PqWckcbe1NjI=";
  };

  nativeBuildInputs = [ xz ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '3.0.6' '${finalAttrs.version}'
    rm -rf bin dist build *.egg-info
  '';

  build-system = [
    setuptools
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
    mkdir -p $out/${python.sitePackages}/refgenDetector/msgpacks
    for f in src/refgenDetector/github_msgpacks/*.xz; do
      echo "unpacking $f"
      xz -dc "$f" > "$out/${python.sitePackages}/refgenDetector/msgpacks/$(basename "$f" .xz)"
    done
  '';

  pythonImportsCheck = [ "refgenDetector" ];

  dontVersionCheck = true;

  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/EGA-archive/refgenDetector";
    license = lib.licenses.gpl3Only;
    description = "Package that infers the reference genome assembly used to generate alignment and VCF files";
    maintainers = with lib.maintainers; [ rub-br ];
    mainProgram = "refgenDetector";
  };
})
