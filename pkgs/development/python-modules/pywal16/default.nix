# This package is almost copy-paset of original Pywal's
# So, I give credit to Fresheyeball, as to maintainer
# Please, feel free to maintain this (I don't know what I'm doing)


{ lib,
  python3,
  fetchPypi,
  imagemagick,
  feh,
  ...
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pywal";
  version = "3.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1drha9kshidw908k7h3gd9ws2bl64ms7bjcsa83pwb3hqa9bkspg";
  };

  patches = [
    ./feh.patch
    ./convert.patch
  ];

  postPatch = ''
    substituteInPlace pywal/backends/wal.py --subst-var-by convert "${imagemagick}/bin/convert"
    substituteInPlace pywal/wallpaper.py --subst-var-by feh "${feh}/bin/feh"
  '';

  preCheck = ''
    mkdir tmp
    HOME=$PWD/tmp

    for f in tests/test_export.py tests/test_util.py ; do
      substituteInPlace "$f" \
        --replace '/tmp/' "$TMPDIR/"
    done
  '';

  # installPhase = ''
  #   mkdir -p ${HOME}/.local/bin/
  # '';

  meta = {
      description = "16 colors fork of pywal";
      mainProgram = "wal";
      homepage = "https://github.com/eylles/pywal16";
      changelog = "https://github.com/eylles/pywal16/blob/${version}/CHANGELOG.md";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ MyGitHubBlueberry ]; /* i am affraid of maintaining this; I would love to change it "Fresheyeball", but idk if i am allowed to */
  };
}
