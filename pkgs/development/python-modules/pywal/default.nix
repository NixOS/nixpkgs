{ lib, python3Packages, imagemagick, feh }:

python3Packages.buildPythonApplication rec {
  pname = "pywal";
  version = "3.2.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1pj30h19ijwhmbm941yzbkgr19q06dhp9492h9nrqw1wfjfdbdic";
  };

  # necessary for imagemagick to be found during tests
  buildInputs = [ imagemagick ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ imagemagick feh ]}" ];

  preCheck = ''
    mkdir tmp
    HOME=$PWD/tmp
  '';

  patches = [
    ./convert.patch
  ];

  postPatch = ''
    substituteInPlace pywal/backends/wal.py --subst-var-by convert "${imagemagick}/bin/convert"
  '';

  meta = with lib; {
    description = "Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3.";
    homepage = https://github.com/dylanaraps/pywal;
    license = licenses.mit;
    maintainers = with maintainers; [ Fresheyeball ];
  };
}
