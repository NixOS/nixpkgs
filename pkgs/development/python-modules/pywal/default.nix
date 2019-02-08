{ lib, buildPythonPackage, fetchPypi, imagemagick, feh, isPy3k }:

buildPythonPackage rec {
  pname = "pywal";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pj30h19ijwhmbm941yzbkgr19q06dhp9492h9nrqw1wfjfdbdic";
  };

  preCheck = ''
    mkdir tmp
    HOME=$PWD/tmp
  '';

  patches = [
    ./convert.patch
    ./feh.patch
  ];

  # Invalid syntax
  disabled = !isPy3k;

  postPatch = ''
    substituteInPlace pywal/backends/wal.py --subst-var-by convert "${imagemagick}/bin/convert"
    substituteInPlace pywal/wallpaper.py --subst-var-by feh "${feh}/bin/feh"
  '';

  meta = with lib; {
    description = "Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3.";
    homepage = https://github.com/dylanaraps/pywal;
    license = licenses.mit;
    maintainers = with maintainers; [ Fresheyeball ];
  };
}
