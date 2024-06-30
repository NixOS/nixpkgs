{ lib
, fetchPypi
, buildPythonApplication
, poetry-core
, colorama
, packaging
, pydantic
, requests
, pygobject3
, tqdm
, gobject-introspection
, wrapGAppsNoGuiHook
}:

buildPythonApplication rec {
  pname = "gnome-extensions-cli";
  version = "0.10.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "gnome_extensions_cli";
    inherit version;
    hash = "sha256-yAoo3NjNtTZSHmbLKzW2X7Cy2smLNp8/9vo+OPGxlVY=";
  };

  nativeBuildInputs = [
    gobject-introspection
    poetry-core
    wrapGAppsNoGuiHook
  ];

  pythonRelaxDeps = [
    "more-itertools"
    "packaging"
  ];

  propagatedBuildInputs = [
    colorama
    packaging
    pydantic
    requests
    pygobject3
    tqdm
  ];

  pythonImportsCheck = [
    "gnome_extensions_cli"
  ];

  meta = with lib; {
    homepage = "https://github.com/essembeh/gnome-extensions-cli";
    description = "Command line tool to manage your GNOME Shell extensions";
    license = licenses.asl20;
    maintainers = with maintainers; [ dylanmtaylor ];
    platforms = platforms.linux;
  };
}
