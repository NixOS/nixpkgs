{
  lib,
  buildPythonPackage,
  fetchPypi,
  imagemagick,
  feh,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "pywal";
  version = "3.8.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eP3Tquvo6enlcyrgscMPDAKnPEkuWPKpJH7CKTNgOzA=";
  };

  patches = [
    ./convert.patch
    ./feh.patch
  ];

  postPatch = ''
    substituteInPlace pywal/backends/wal.py --subst-var-by convert "${imagemagick}/bin/convert"
    substituteInPlace pywal/wallpaper.py --subst-var-by feh "${feh}/bin/feh"
  '';

  # Invalid syntax
  disabled = !isPy3k;

  preCheck = ''
    mkdir tmp
    HOME=$PWD/tmp

    for f in tests/test_export.py tests/test_util.py ; do
      substituteInPlace "$f" \
        --replace '/tmp/' "$TMPDIR/"
    done
  '';

  meta = {
    description = "Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3";
    mainProgram = "wal";
    homepage = "https://github.com/dylanaraps/pywal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Fresheyeball ];
  };
}
