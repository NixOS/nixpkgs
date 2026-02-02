{
  lib,
  python,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  hatchling,
  hatch-fancy-pypi-readme,
  libgpiod,
  mock,
}:
buildPythonPackage (finalAttrs: {
  pname = "gpiodevice";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimoroni";
    repo = "gpiodevice-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1vZHRCHUmG+t0TYxYzc2qwElKrcLa0WmQ+FI5GTN1A8=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    libgpiod
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gpiodevice" ];

  # The build explicitly copies over these docs files, which cause collisions with other pimoroni repos.
  # Preserve the files (especially license), but move elsewhere.
  postInstall = ''
    mkdir -p $out/share/doc/${finalAttrs.pname}
    mkdir -p $out/share/licenses/${finalAttrs.pname}

    mv "$out/${python.sitePackages}/LICENSE" $out/share/licenses/${finalAttrs.pname}
    mv "$out/${python.sitePackages}/README.md" $out/share/doc/${finalAttrs.pname}/
    mv "$out/${python.sitePackages}/CHANGELOG.md" $out/share/doc/${finalAttrs.pname}/
  '';

  meta = {
    description = "Helper library for working with Linux gpiochip devices";
    homepage = "https://github.com/pimoroni/gpiodevice-python";
    changelog = "https://github.com/pimoroni/gpiodevice-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theconcierge ];
  };
})
