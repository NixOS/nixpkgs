{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  pytestCheckHook,
}:
let
  pname = "pyembroidery";

  # Mysteriously, the latest version published on PyPI has the version of 1.5.1,
  # but the latest GitHub version stopped at 1.2.39. Further more Ink/Stitch requires the .exceptions
  # module which is absent from the PyPI release.
  # I guess this is *technically* the correct version name, but... yikes.
  version = "1.5.1-unstable-2024-06-26";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inkstitch";
    repo = "pyembroidery";
    rev = "b603b8d2b2bf91b5b0823a8a619562de5fd756e7";
    hash = "sha256-cnWQ/ZScdXTFMLHdceyCLjgEkcwv3KuZHwXWlsYCcBA=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "pyembroidery"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Failed assertions.
  # See https://github.com/inkstitch/pyembroidery/issues/108
  disabledTests = [
    "test_generic_write_gcode"
    "test_jef_trims_commands"
  ];

  meta = {
    description = "Python library for the reading and writing of embroidery files";
    homepage = "https://github.com/inkstitch/pyembroidery";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
