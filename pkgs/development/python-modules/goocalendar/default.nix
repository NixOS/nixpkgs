{ lib
<<<<<<< HEAD
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
=======
, fetchPypi
, buildPythonPackage
, pkg-config
, gtk3
, gobject-introspection
, pygobject3
, goocanvas2
, isPy3k
 }:

buildPythonPackage rec {
  pname = "GooCalendar";
  version = "0.7.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "318b3b7790ac9d6d98881eee3b676fc9c17fc15d21dcdaff486e3c303333b41a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  pythonImportsCheck = [
    "goocalendar"
  ];

  meta = with lib; {
    description = "A calendar widget for GTK using PyGoocanvas";
    homepage = "https://goocalendar.tryton.org/";
    changelog = "https://foss.heptapod.net/tryton/goocalendar/-/blob/${version}/CHANGELOG";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ udono ];
=======
  meta = with lib; {
    description = "A calendar widget for GTK using PyGoocanvas.";
    homepage = "https://goocalendar.tryton.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.udono ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
