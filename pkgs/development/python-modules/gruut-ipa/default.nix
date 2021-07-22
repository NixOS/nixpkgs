{ lib
, buildPythonPackage
, fetchFromGitHub
, pkgs
, python
}:

buildPythonPackage rec {
  pname = "gruut-ipa";
  version = "0.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = pname;
    # https://github.com/rhasspy/gruut-ipa/issues/3
    rev = "3791c76a24dbcc745f143603f37292c0b346228d";
    sha256 = "1zygylddlzkr1rlahzw0dip20par56zglk13wp75ylyicijrd00k";
  };

  postPatch = ''
    patchShebangs bin/speak-ipa
    substituteInPlace bin/speak-ipa \
      --replace '${"\${src_dir}:"}' "$out/lib/${python.libPrefix}/site-packages:" \
      --replace "do espeak" "do ${pkgs.espeak}/bin/espeak"
  '';

  postInstall = ''
    install -m0755 bin/speak-ipa $out/bin/speak-ipa
  '';

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
