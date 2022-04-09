{ lib
, buildPythonPackage
, fetchFromGitHub
, espeak
, numpy
, python
}:

buildPythonPackage rec {
  pname = "gruut-ipa";
  version = "0.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q2UKELoG8OaAPxIrZNCpXgeWZ2fCzb3g3SOVzCm/gg0=";
  };

  postPatch = ''
    patchShebangs bin/*
    substituteInPlace bin/speak-ipa \
      --replace '${"\${src_dir}:"}' "$out/lib/${python.libPrefix}/site-packages:" \
      --replace "do espeak" "do ${espeak}/bin/espeak"
  '';

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [
    "gruut_ipa"
  ];

  meta = with lib; {
    description = "Library for manipulating pronunciations using the International Phonetic Alphabet (IPA)";
    homepage = "https://github.com/rhasspy/gruut-ipa";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
