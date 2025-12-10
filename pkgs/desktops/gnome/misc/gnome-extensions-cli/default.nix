{
  lib,
  fetchPypi,
  buildPythonApplication,
  poetry-core,
  colorama,
  packaging,
  pydantic,
  requests,
  pygobject3,
  tqdm,
  gobject-introspection,
  wrapGAppsNoGuiHook,
}:

buildPythonApplication rec {
  pname = "gnome-extensions-cli";
  version = "0.10.8";
  format = "pyproject";

  src = fetchPypi {
    pname = "gnome_extensions_cli";
    inherit version;
    hash = "sha256-Tnf8BbW9u7d19ZtGTdMVHa6azbKekYRGOPEPNiB+y00=";
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

  meta = {
    homepage = "https://github.com/essembeh/gnome-extensions-cli";
    description = "Command line tool to manage your GNOME Shell extensions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    platforms = lib.platforms.linux;
  };
}
