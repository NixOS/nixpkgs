{
  lib,
  fetchPypi,
  python3Packages,
  plover,
  plover-dict-commands,
  plover-last-translation,
  plover-modal-dictionary,
  plover-python-dictionary,
  plover-stitching,
  setuptools,
  pythonImportsCheckHook,
}:
python3Packages.buildPythonPackage rec {
  pname = "plover-lapwing-aio";
  version = "1.3.4";
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    description = "Automatically installs all the necessary plugins and dictionaries for using Lapwing theory with Plover";
    maintainers = with maintainers; [ twey ];
    license = licenses.gpl2Plus;
  };

  src = fetchPypi {
    pname = "plover_lapwing_aio";
    inherit version;
    hash = "sha256-0GqmWGe5uN2JfnH/XMWrIH5As3xueREBU6nk3gGi3Vw=";
  };

  nativeCheckInputs = [
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = [
    plover
    plover-dict-commands
    plover-last-translation
    plover-modal-dictionary
    plover-python-dictionary
    plover-stitching
  ];
}
