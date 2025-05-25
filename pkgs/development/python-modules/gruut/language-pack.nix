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

  meta = with lib; {
    description = "Language files for gruut tokenizer/phonemizer";
    homepage = "https://github.com/rhasspy/gruut";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
