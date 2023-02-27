{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, manim
, mutagen
, pydub
, humanhash3
, sox
, pip
, python-dotenv
, gtts
, pynput
, pyaudio
, playsound
, stable-ts
, pygobject3
, gst_all_1
, wrapGAppsHook
, intltool
, ffmpeg
, pkgs
}:

buildPythonPackage rec {
  pname = "manim-voiceover";
  format = "pyproject";
  version = "0.3.0";
  disabled = pythonOlder "3.7";


  src = fetchFromGitHub {
    owner  = "ManimCommunity";
    repo = "manim-voiceover";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ugR435frhpleyzHG6cbKnTTyqRVpRKPBLkaZQ+E8Cwo=";
  };

  nativeBuildInputs = [
    poetry-core
    wrapGAppsHook
    ffmpeg
    pkgs.sox
  ];

  passthru.optional-dependencies = {
    gtts = [ gtts ];
    recorder = [ pyaudio pynput playsound ];
    transcribe = [ stable-ts ];
  };

  propagatedBuildInputs = [
    manim
    mutagen
    pydub
    humanhash3
    python-dotenv
    sox
    pygobject3
    intltool
    pip
  ];

  # no real test
  doCheck = false;

  pythonImportsCheck = [ "manim_voiceover" ];

  meta = with lib; {
    description = "Manim plugin for all things voiceover";
    homepage = "https://voiceover.manim.community";
    license = licenses.mit;
    maintainers = with maintainers; [ FaustXVI ];
  };
}
