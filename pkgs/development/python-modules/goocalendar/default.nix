{ lib
, buildPythonPackage
, fetchPypi
, gobject-introspection
, goocanvas2
, gtk3
, pkg-config
, pygobject3
, pythonOlder
 }:

buildPythonPackage rec {
  pname = "goocalendar";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "GooCalendar";
    inherit version;
    hash = "sha256-LwL5TLRkD6ALucabLUeB0k4rIX+O/aW2ebS2rZPjIUs=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  propagatedBuildInputs = [
    pygobject3
  ];

  buildInputs = [
    gtk3
    goocanvas2
  ];

  # No upstream tests available
  doCheck = false;

  pythonImportsCheck = [
    "goocalendar"
  ];

  meta = with lib; {
    description = "A calendar widget for GTK using PyGoocanvas";
    homepage = "https://goocalendar.tryton.org/";
    changelog = "https://foss.heptapod.net/tryton/goocalendar/-/blob/${version}/CHANGELOG";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ udono ];
  };
}
