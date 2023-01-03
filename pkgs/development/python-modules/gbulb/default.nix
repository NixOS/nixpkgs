{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pygobject3
, pytestCheckHook
, gtk3
, gobject-introspection
}:

buildPythonPackage rec {
  pname = "gbulb";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "beeware";
    repo = "gbulb";
    rev = "v${version}";
    sha256 = "sha256-QNpZf1zfe6r6MtmYMWSrXPsXm5iX36oMx4GnXiTYPaQ=";
  };

  propagatedBuildInputs = [
    pygobject3
    gtk3
  ];

  checkInputs = [
    pytestCheckHook
    gobject-introspection
  ];

  disabledTests = [
    "test_glib_events.TestBaseGLibEventLoop" # Somtimes fail due to imprecise timing
  ];

  pythonImportsCheck = [ "gbulb" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "GLib implementation of PEP 3156";
    homepage = "https://github.com/beeware/gbulb";
    license = licenses.asl20;
    maintainers = with maintainers; [ marius851000 ];
  };
}
