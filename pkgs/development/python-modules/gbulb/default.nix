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
  version = "0.6.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "beeware";
    repo = "gbulb";
    rev = "refs/tags/v${version}";
    hash = "sha256-AdZSvxix0cpoFQSrslGl+hB/s6Nh0EsWMQmXZAJVJOg=";
  };

  propagatedBuildInputs = [
    pygobject3
    gtk3
  ];

  nativeCheckInputs = [
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
