{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, useGtk3 ? false
, useLibsoup2 ? false
}:

let
  config = lib.optionals useGtk3 [
    "Gtk3"
    "Gdk3"
    "GtkSource4"
  ] ++ lib.optionals useLibsoup2 [
    "Soup2"
  ];
in
buildPythonPackage rec {
  pname = "pygobject-stubs";
  version = "2.3.1";

  format = "pyproject";

  src = fetchPypi {
    pname = "PyGObject-stubs";
    inherit version;
    hash = "sha256-GgXQD6/mGtMh42u6ohgEEEsidsvPuRI1TJz+BPDC6u4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  env = lib.optionalAttrs (config != []) {
    # Choose which version of libraries to use since only one version can be exported under the name.
    PYGOBJECT_STUB_CONFIG = lib.concatStringsSep "," config;
  };

  # Nothing to check.
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for PyGObject";
    homepage = "https://github.com/pygobject/pygobject-stubs";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
  };
}
