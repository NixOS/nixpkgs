{
  lib,
  buildPythonPackage,
  fetchPypi,
  ply,
  roman,
  uqbar,
  pythonOlder,
  pytestCheckHook,
  lilypond,
}:

buildPythonPackage rec {
  pname = "abjad";
  version = "3.19";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I9t3ORUKFFlMfXJsAzXhCzl1B4a9/ZNmvSX2/R44TPs=";
  };

  propagatedBuildInputs = [
    ply
    roman
    uqbar
  ];

  buildInputs = [ lilypond ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace abjad/io.py \
      --replace 'lilypond_path = self.get_lilypond_path()' \
                'lilypond_path = "${lilypond}/bin/lilypond"'
    # general invocations of binary for IO purposes

    substituteInPlace abjad/configuration.py \
      --replace '["lilypond"' '["${lilypond}/bin/lilypond"'
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
