{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, isPy27
, mpv
, setuptools
, pytestCheckHook
, xvfbwrapper
, xorgserver
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "1.0.3";
  format = "pyproject";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    rev = "v${version}";
    hash = "sha256-BM9vb0KPA9ChZC2bJ3f8F9PrCkwIom1lQTzbCo5UOcc=";
  };

  propagatedBuildInputs = [ setuptools ];

  buildInputs = [ mpv ];

  postPatch = ''
    substituteInPlace mpv.py \
      --replace "sofile = ctypes.util.find_library('mpv')" \
                'sofile = "${mpv}/lib/libmpv${stdenv.targetPlatform.extensions.sharedLibrary}"'
  '';

  nativeCheckInputs = [
    xorgserver
  ];

  checkInputs = [
    pytestCheckHook
    xvfbwrapper
  ];

  pythonImportsCheck = [ "mpv" ];

  meta = with lib; {
    description = "A python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
