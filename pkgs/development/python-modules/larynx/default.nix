{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

, openblas
, gomp
, libatomic_ops

, dataclasses-json
, gruut
, numpy
, onnxruntime
, phonemes2ids
, python-pidfile
, psutil
, pytorch
, tqdm
}:

buildPythonPackage rec {
  pname = "larynx";
  version = "1.1.0";

  voices_version = "2021-03-28";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f073ce1ef1ae0ce806e896dfee9fd242c287964eeaf46c9587ad33d5c4efc83";
  };

  # TODO: add voices to package? (https://github.com/rhasspy/larynx/releases/tag/2021-03-28)
  voices = [
    "de-de_eva_k-glow_tts"
    "de-de_karlsson-glow_tts"
    "de-de_pavoque-glow_tts"
    "de-de_rebecca_braunert_plunkett-glow_tts"
    "de-de_thorsten-glow_tts"
    "en-us_blizzard_fls-glow_tts"
    "en-us_cmu_aew-glow_tts"
    "en-us_cmu_ahw-glow_tts"
    "en-us_cmu_aup-glow_tts"
    "en-us_cmu_bdl-glow_tts"
    "en-us_cmu_clb-glow_tts"
    "en-us_cmu_eey-glow_tts"
    "en-us_cmu_fem-glow_tts"
    "en-us_cmu_jmk-glow_tts"
    "en-us_cmu_ksp-glow_tts"
    "en-us_cmu_ljm-glow_tts"
    "en-us_cmu_lnh-glow_tts"
    "en-us_cmu_rms-glow_tts"
    "en-us_cmu_rxr-glow_tts"
    "en-us_cmu_slp-glow_tts"
    "en-us_cmu_slt-glow_tts"
    "en-us_ek-glow_tts"
    "en-us_harvard-glow_tts"
    "en-us_kathleen-glow_tts"
    "en-us_ljspeech-glow_tts"
    "en-us_mary_ann-glow_tts"
    "es-es_carlfm-glow_tts"
    "es-es_karen_savage-glow_tts"
    "fr-fr_gilles_le_blanc-glow_tts"
    "fr-fr_siwis-glow_tts"
    "fr-fr_tom-glow_tts"
    "it-it_lisa-glow_tts"
    "it-it_riccardo_fasol-glow_tts"
    "nl_bart_de_leeuw-glow_tts"
    "nl_flemishguy-glow_tts"
    "nl_rdh-glow_tts"
    "ru-ru_hajdurova-glow_tts"
    "ru-ru_minaev-glow_tts"
    "ru-ru_nikolaev-glow_tts"
    "sv-se_talesyntese-glow_tts"
    "sw_biblia_takatifu-glow_tts"
    "en-us_southern_english_female-glow_tts"
    "en-us_southern_english_male-glow_tts"
    "en-us_blizzard_lessac-glow_tts"
    "en-us_scottish_english_male-glow_tts"
    "en-us_northern_english_male-glow_tts"
    "en-us_judy_bieber-glow_tts"
    "de-de_hokuspokus-glow_tts"
    "de-de_kerstin-glow_tts"
    "nl_nathalie-glow_tts"
    "en-us_glados-glow_tts"
  ];

  propagatedBuildInputs = [
    openblas
    gomp
    libatomic_ops
    dataclasses-json
    gruut
    numpy
    onnxruntime
    phonemes2ids
    python-pidfile
    psutil
    pytorch
    tqdm
  ];

  patches = [
    ./remove-server.patch
  ];

  meta = with lib; {
    description = "Neural text to speech system using the International Phonetic Alphabet";
    homepage = https://github.com/rhasspy/larynx;
    license = licenses.mit;
    maintainers = [ maintainers.tilcreator ];
  };
}
