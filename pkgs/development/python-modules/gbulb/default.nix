{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pygobject3,
  pytestCheckHook,
  gtk3,
  gobject-introspection,
}:

buildPythonPackage rec {
  pname = "gbulb";
  version = "0.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beeware";
    repo = "gbulb";
    rev = "refs/tags/v${version}";
    hash = "sha256-03Ott+V3Y4+Y72Llsug5coqG3C+pjAdLkPYbaY/6Uow=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "==" ">="
  '';

  build-system = [ setuptools-scm ];

  dependencies = [ pygobject3 ];

  buildInputs = [ gtk3 ];

  nativeCheckInputs = [
    pytestCheckHook
    gobject-introspection
  ];

  disabledTests = [
    "test_glib_events.TestBaseGLibEventLoop" # Somtimes fail due to imprecise timing
  ];

  pythonImportsCheck = [ "gbulb" ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "GLib implementation of PEP 3156";
    homepage = "https://github.com/beeware/gbulb";
    license = licenses.asl20;
    maintainers = with maintainers; [ marius851000 ];
  };
}
