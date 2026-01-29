{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-fancy-pypi-readme,
  hatch-requirements-txt,
  numpy,
  pillow,
  smbus2,
  spidev,
  gpiodevice,
}:
buildPythonPackage rec {
  pname = "inky";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimoroni";
    repo = "inky";
    tag = "v${version}";
    hash = "sha256-4bGX1NQ/y67Ctm9yWAlH+UZFYejdUJ1i/h8fEbQeZog=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
    hatch-requirements-txt
  ];

  dependencies = [
    numpy
    pillow
    smbus2
    spidev
    gpiodevice
  ];

  pythonImportsCheck = [ "inky" ];

  postInstall = ''
    # the build explicitly copies over these docs files, which cause collisions with other pimoroni repos
    # preserve the files (especially license), but move elsewhere

    mkdir -p $out/share/doc/${pname}
    mkdir -p $out/share/licenses/${pname}

    mv "$out/${python.sitePackages}/LICENSE" $out/share/licenses/${pname}/
    mv "$out/${python.sitePackages}/README.md" $out/share/doc/${pname}/
    mv "$out/${python.sitePackages}/CHANGELOG.md" $out/share/doc/${pname}/
  '';

  meta = {
    description = "Python library for Inky pHAT, Inky wHAT and Inky Impression e-paper displays for Raspberry Pi.";
    homepage = "https://github.com/pimoroni/inky";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theconcierge ];
  };
}
