{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  ply,
  roman,
  uqbar,
  pytestCheckHook,
  lilypond,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "abjad";
  version = "3.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Abjad";
    repo = "abjad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Nwq/NNQshGHvFkmLBYXgv97++h86kmoOCPKnYElnu4=";
  };

  # uses python 3.13 function generic syntax
  disabled = pythonOlder "3.13";

  build-system = [ setuptools ];

  dependencies = [
    ply
    roman
    uqbar
    typing-extensions
  ];

  buildInputs = [ lilypond ];

  postPatch = ''
    substituteInPlace source/abjad/configuration.py \
      --replace-fail '["lilypond"' '["${lib.getExe lilypond}"' \
      --replace-fail '"default": "lilypond",' '"default": "${lib.getExe lilypond}",'
  '';

  pythonImportsCheck = [ "abjad" ];

  preCheck = ''
    rm -rf source # this causes some pycache issues
  '';

  nativeCheckInputs = [ pytestCheckHook ];

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
})
