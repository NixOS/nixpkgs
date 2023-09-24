{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, mpv
, setuptools
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "1.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    rev = "v${version}";
    hash = "sha256-qP5Biw4sTLioAhmMZX+Pemue2PWc3N7afAe38dwJv3U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [ mpv ];

  postPatch = ''
    substituteInPlace mpv.py \
      --replace "sofile = ctypes.util.find_library('mpv')" \
                'sofile = "${mpv}/lib/libmpv${stdenv.targetPlatform.extensions.sharedLibrary}"'
  '';

  # tests impure, will error if it can't load libmpv.so
  doCheck = false;
  pythonImportsCheck = [ "mpv" ];

  meta = with lib; {
    description = "A python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
