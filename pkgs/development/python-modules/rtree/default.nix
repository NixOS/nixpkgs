{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  libspatialindex,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "rtree";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Toblerity";
    repo = "rtree";
    rev = "refs/tags/${version}";
    hash = "sha256-RmAiyYrkUMBN/ebmo27WvFcRmYlKkywuQHLLUbluTTw=";
  };

  patches = [
    # https://github.com/Toblerity/rtree/pull/313
    (fetchpatch {
      url = "https://github.com/Toblerity/rtree/commit/9a08ab91a8253b8f006d176ed698c948987e471e.patch";
      sha256 = "sha256-+t0DU4qGULi8w7W77sNhTKDWdW9Zd67qjdySQXOlQyU=";
    })
  ];

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
    changelog = "https://github.com/Toblerity/rtree/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ bgamari ];
  };
}
