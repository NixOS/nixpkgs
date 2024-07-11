{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  wheel,
  tkinter,
  darkdetect,
}:
let
  pname = "customtkinter";
  version = "5.2.2";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/Y2zuvqWHJgu5gMNuoC0wuJYWGMHVrUTmG2xkRPY0gc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];
  buildInputs = [ tkinter ];
  propagatedBuildInputs = [ darkdetect ];

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "customtkinter" ];

  meta = {
    description = "Modern and customizable python UI-library based on Tkinter";
    homepage = "https://github.com/TomSchimansky/CustomTkinter";
    license = lib.licenses.mit;
    longDescription = ''
      CustomTkinter is a python UI-library based on Tkinter, which provides
      new, modern and fully customizable widgets. They are created and
      used like normal Tkinter widgets and can also be used in combination
      with normal Tkinter elements. The widgets and the window colors
      either adapt to the system appearance or the manually set mode
      ('light', 'dark'), and all CustomTkinter widgets and windows support
      HighDPI scaling (Windows, macOS). With CustomTkinter you'll get
      a consistent and modern look across all desktop platforms
      (Windows, macOS, Linux).
    '';
    maintainers = with lib.maintainers; [ donteatoreo ];
  };
}
