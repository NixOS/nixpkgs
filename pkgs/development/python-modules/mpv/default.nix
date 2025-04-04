{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  mpv,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "1.0.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    rev = "v${version}";
    hash = "sha256-2sYWTzj7+ozezNX0uFdJW+A0K6bwAmiVvqo/lr9UToA=";
  };

  patches = [
    # https://github.com/jellyfin/jellyfin-mpv-shim/issues/448
    (fetchpatch {
      url = "https://github.com/jaseg/python-mpv/commit/12850b34bd3b64704f8abd30341a647a73719267.patch";
      hash = "sha256-2O7w8PeWinCzrigGX3IV+9PVCtU9KCM2UJ32Y1kE6m0=";
    })
  ];

  disabled = pythonOlder "3.9";

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ mpv ];

  postPatch = ''
    substituteInPlace mpv.py \
      --replace-fail "sofile = ctypes.util.find_library('mpv')" \
                     'sofile = "${mpv}/lib/libmpv${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  pythonImportsCheck = [ "mpv" ];

  meta = with lib; {
    description = "Python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
