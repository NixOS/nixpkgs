{
  lib,
  buildPythonPackage,

  lang,
  version,
  src,
  build-system,
}:

buildPythonPackage rec {
  pname = "gruut-lang-${lang}";
  pyproject = true;
  inherit version src build-system;

  prePatch = ''
    cd "${pname}"
  '';

  pythonImportsCheck = [ "gruut_lang_${lang}" ];

  doCheck = false;

  meta = {
    description = "Language files for gruut tokenizer/phonemizer";
    homepage = "https://github.com/rhasspy/gruut";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
}
