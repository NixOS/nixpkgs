{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  mpv,
  setuptools,
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

  patches = [
    # https://github.com/jellyfin/jellyfin-mpv-shim/issues/448
    (fetchpatch {
      url = "https://github.com/jaseg/python-mpv/commit/12850b34bd3b64704f8abd30341a647a73719267.patch";
      hash = "sha256-2O7w8PeWinCzrigGX3IV+9PVCtU9KCM2UJ32Y1kE6m0=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ mpv ];

  postPatch = ''
    substituteInPlace mpv.py \
      --replace-fail "sofile = ctypes.util.find_library('mpv')" \
                     'sofile = "${mpv}/lib/libmpv${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  pythonImportsCheck = [ "mpv" ];

  meta = {
    description = "Python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
