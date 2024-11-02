{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  mpv,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "1.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    rev = "v${version}";
    hash = "sha256-1axVJ8XXs0ZPgsVux3+6YUm1KttLceZyyHOuUEHIFl4=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ mpv ];

  postPatch = ''
    substituteInPlace mpv.py \
      --replace "sofile = ctypes.util.find_library('mpv')" \
                'sofile = "${mpv}/lib/libmpv${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  # tests impure, will error if it can't load libmpv.so
  doCheck = false;
  pythonImportsCheck = [ "mpv" ];

  meta = with lib; {
    description = "Python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
