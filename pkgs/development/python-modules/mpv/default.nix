{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  mpv,
  setuptools,
  pytestCheckHook,
  pyvirtualdisplay,
  xvfb,
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    tag = "v${version}";
    hash = "sha256-MHdQnnjxnbOkIf56VLGi7vgNbrjhU/ODUBdZoXjxXxE=";
  };

  postPatch = ''
    substituteInPlace mpv.py \
      --replace-fail "sofile = ctypes.util.find_library('mpv')" \
                     'sofile = "${mpv}/lib/libmpv${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  build-system = [ setuptools ];

  buildInputs = [ mpv ];

  nativeCheckInputs = [
    pytestCheckHook
    pyvirtualdisplay
  ]
  ++ lib.optionals stdenv.isLinux [
    xvfb
  ];

  pythonImportsCheck = [ "mpv" ];

  meta = {
    description = "Python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
