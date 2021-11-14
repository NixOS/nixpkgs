{ lib
, buildPythonPackage
, fetchFromGitHub
, pkgs
, python
}:

buildPythonPackage rec {
  pname = "gruut-ipa";
  version = "0.11.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = pname;
    rev = "v${version}";
    sha256 = "08n79v60jhkz5vhychsicjz4bhz8v4gb2djmz5dfdaivyr0h3bsf";
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
