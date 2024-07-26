{ lib, buildPythonPackage, fetchPypi, imagemagick, feh, isPy3k }:

buildPythonPackage rec {
  pname = "pywal";
  version = "3.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1drha9kshidw908k7h3gd9ws2bl64ms7bjcsa83pwb3hqa9bkspg";
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

  meta = with lib; {
    description = "Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3";
    homepage = "https://github.com/dylanaraps/pywal";
    license = licenses.mit;
    maintainers = with maintainers; [ Fresheyeball ];
  };
}
