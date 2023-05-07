{ lib
, fetchPypi
, buildPythonApplication
, poetry-core
, colorama
, more-itertools
, packaging
, pydantic
, requests
, pygobject3
, gobject-introspection
, wrapGAppsNoGuiHook
}:

buildPythonApplication rec {
  pname = "gnome-extensions-cli";
  version = "0.9.5";
  format = "pyproject";

  src = fetchPypi {
    pname = "gnome_extensions_cli";
    inherit version;
    hash = "sha256-4eRVmG5lqK8ql9WpvXsf18znOt7kDSnpQnLfy73doy4=";
  };

  nativeBuildInputs = [
    gobject-introspection
    poetry-core
    wrapGAppsNoGuiHook
  ];

  propagatedBuildInputs = [
    colorama
    more-itertools
    packaging
    pydantic
    requests
    pygobject3
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
