{
  lib,
  buildPythonPackage,
  fetchPypi,
  ply,
  roman,
  uqbar,
  pythonOlder,
  pythonAtLeast,
  pytestCheckHook,
  lilypond,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "abjad";
  version = "3.28";
  format = "setuptools";

  # see issue upstream indicating Python 3.12 support will come
  # with version 3.20: https://github.com/Abjad/abjad/issues/1574
  disabled = pythonOlder "3.10" || pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J4LPOSz34GvDRwpCG8yt4LAqt+dhDrfG/W451bZRpgk=";
  };

  propagatedBuildInputs = [
    ply
    roman
    uqbar
    typing-extensions
  ];

  buildInputs = [ lilypond ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace abjad/io.py \
      --replace-fail 'lilypond_path = self.get_lilypond_path()' \
                'lilypond_path = "${lilypond}/bin/lilypond"'
    # general invocations of binary for IO purposes

    substituteInPlace abjad/configuration.py \
      --replace-fail '["lilypond"' '["${lilypond}/bin/lilypond"'
    # get_lilypond_version_string
  '';

  pythonImportsCheck = [ "abjad" ];

  meta = {
    description = "GNU LilyPond wrapper for Python";
    longDescription = ''
      Abjad helps composers build up complex pieces of music notation in
      iterative and incremental ways. Use Abjad to create a symbolic
      representation of all the notes, rests, chords, tuplets, beams and slurs
      in any score. Because Abjad extends the Python programming language, you
      can use Abjad to make systematic changes to music as you work. Because
      Abjad wraps the LilyPond music notation package, you can use Abjad to
      control the typographic detail of symbols on the page.
    '';
    license = lib.licenses.mit;
    homepage = "https://abjad.github.io/";
    changelog = "https://abjad.github.io/appendices/changes.html";
    maintainers = [ lib.maintainers.davisrichard437 ];
  };
}
