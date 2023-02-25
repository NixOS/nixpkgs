{ lib
, buildPythonPackage
, fetchFromGitHub
, pygobject3
, pythonOlder
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
  version = "2.10.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pygobject-stubs";
    rev = "refs/tags/v${version}";
    hash = "sha256-fz+qzFWl9JJu9CEVkeiV6XUIPDvwWgrfhTo/nj1EH5c=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # This package does not include any tests.
  doCheck = false;

  env = lib.optionalAttrs (config != []) {
    # Choose which version of libraries to use since only one version can be exported under the name.
    PYGOBJECT_STUB_CONFIG = lib.concatStringsSep "," config;
  };

  meta = with lib; {
    description = "PEP 561 Typing Stubs for PyGObject";
    homepage = "https://github.com/pygobject/pygobject-stubs";
    changelog = "https://github.com/pygobject/pygobject-stubs/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hacker1024 ];
  };
}
