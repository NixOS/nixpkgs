{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, urwid
, wxPython_4_0
, six
, flake8
, sphinx
, pygobject3
, pyqt4

# The following options control GUI functionality. Disabling them results in parts
# of the library and certain user-facing scripts not working. They are here if
# you need to avoid the dependencies these features pull in (e.g. in a headless
# scenario).
, urwidSupport ? true
, wxPythonSupport ? true
, gtkSupport ? true
, qtSupport ? true
}:

assert urwidSupport -> urwid != null;
assert wxPythonSupport -> wxPython_4_0 != null;

with stdenv.lib;
buildPythonPackage rec {
  pname = "hachoir";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "030lffprlw371ciplsf2mszc55jx2pyzx192j1jkwbf3z0wim9qa";
  };

  # setuptoolsCheckPhase is broken, tox and runtests.py fail only when run from
  # nix check phase
  doCheck = false;

  checkInputs = [ flake8 sphinx ];
  propagatedBuildInputs = [ six ]
      ++ (optional urwidSupport urwid)
      ++ (optional wxPythonSupport wxPython_4_0)
      ++ (optional gtkSupport pygobject3)
      ++ (optional qtSupport pyqt4);

  meta = with lib; {
    description = "Package of Hachoir parsers used to open binary files";
    homepage    = "http://hachoir.readthedocs.io/en/latest/install.html";
    license     = lib.licenses.gpl2;
    maintainers = with maintainers; [ dadada ];
  };
}
