# This package is almost copy-paset of original Pywal's
# So, I give credit to Fresheyeball, as to maintainer
# Please, feel free to maintain this (I don't know what I'm doing)


{ lib,
  buildPythonPackage,
  fetchPypi,
  imagemagick,
  swww, #feh
  ...
}:

buildPythonPackage rec {
  pname = "pywal16";
  version = "3.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Jr4yJqbFVqQHoOgKIWyEM4b7sacFIEvhxakcS5ozM+I=";
  };

  patches = [
    # ./feh.patch
    ./convert.patch
  ];

    # substituteInPlace pywal/wallpaper.py --subst-var-by feh "${feh}/bin/feh"
  postPatch = ''
    substituteInPlace pywal/backends/wal.py --subst-var-by convert "${imagemagick}/bin/convert"
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
