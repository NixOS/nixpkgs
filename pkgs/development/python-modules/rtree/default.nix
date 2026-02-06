{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libspatialindex,
  numpy,
  pytestCheckHook,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "rtree";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toblerity";
    repo = "rtree";
    tag = version;
    hash = "sha256-ilhHBAYa4GaKUt8CmmJRS569D9INHZmWS6lK/+AIiqY=";
  };

  postPatch = ''
    substituteInPlace rtree/finder.py --replace \
      'find_library("spatialindex_c")' '"${libspatialindex}/lib/libspatialindex_c${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  buildInputs = [ libspatialindex ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rtree" ];

  meta = {
    description = "R-Tree spatial index for Python GIS";
    homepage = "https://github.com/Toblerity/rtree";
    changelog = "https://github.com/Toblerity/rtree/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bgamari ];
    teams = [ lib.teams.geospatial ];
  };
}
