{
  lib,
  fetchFromGitHub,
  python3Packages,
  setuptools,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "jpegiptc";
  version = "1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdegoulet";
    repo = "JpegIPTC";
    tag = "v${version}";
    hash = "sha256-5yWDDF0JFGY3JxvvyHj7bLGjwo/tJM2ZqN0AmSQdZjs=";
  };

  build-system = [
    setuptools
  ];

  # tests do not use pytest but some self written scripts
  doCheck = false;

  pythonImportsCheck = [
    "JpegIPTC"
  ];

  meta = {
    description = "Extract APP13 (iptc data) from image and raw copy APP13 to another image";
    homepage = "https://github.com/gdegoulet/JpegIPTC";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sephi ];
  };
}
