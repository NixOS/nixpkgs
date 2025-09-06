{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libspatialindex,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "rtree";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

  meta = with lib; {
    description = "R-Tree spatial index for Python GIS";
    homepage = "https://github.com/Toblerity/rtree";
    changelog = "https://github.com/Toblerity/rtree/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ bgamari ];
    teams = [ teams.geospatial ];
  };
}
