{
  lib,
  buildPythonPackage,

  lang,
  version,
  format,
  src,
}:

buildPythonPackage rec {
  pname = "gruut-lang-${lang}";
  inherit version format src;

  prePatch = ''
    cd "${pname}"
  '';

  pythonImportsCheck = [ "gruut_lang_${lang}" ];

  doCheck = false;

  meta = with lib; {
    description = "Language files for gruut tokenizer/phonemizer";
    homepage = "https://github.com/rhasspy/gruut";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
