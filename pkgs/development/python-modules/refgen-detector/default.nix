{
  fetchFromGitHub,
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
  xz,
}:

buildPythonPackage (finalAttrs: {
  pname = "refgenDetector";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "EGA-archive";
    repo = "refgenDetector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4mywVm+iF5yaaWI6Liv1ilz5ZhBoI6PqWckcbe1NjI=";
  };

  format = "setuptools";

  nativeBuildInputs = [ xz ];

  postPatch = ''
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
