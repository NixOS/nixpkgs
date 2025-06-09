{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
  libmediainfo,
  pdm-backend,
  pytest,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pymediainfo";
  version = "7.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DV31nsxhXiTFbzA7j2UVecasyrcmVxXl1CkYbXuiFRQ=";
  };

  postPatch = ''
    substituteInPlace src/pymediainfo/__init__.py \
      --replace "libmediainfo.0.dylib" \
                "${libmediainfo}/lib/libmediainfo.0${stdenv.hostPlatform.extensions.sharedLibrary}" \
      --replace "libmediainfo.dylib" \
                "${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}" \
      --replace "libmediainfo.so.0" \
                "${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}.0"
  '';

  build-system = [ pdm-backend ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    py.test -k 'not test_parse_url' tests
  '';

  pythonImportsCheck = [ "pymediainfo" ];

  meta = {
    description = "Python wrapper for the mediainfo library";
    homepage = "https://github.com/sbraz/pymediainfo";
    changelog = "https://github.com/sbraz/pymediainfo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philipdb ];
  };
}
