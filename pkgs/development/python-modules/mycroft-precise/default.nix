{ buildPythonPackage
, stdenv
, autoreconfHook
, fetchFromGitHub
, fetchpatch
, pkgconfig
, alsaLib
, libtool
, icu
, libpulseaudio

, scipy
# , bbopt
, tensorflow_2
, prettyparse
, Keras
, wavio
, pyache
, precise-runner
, pyaudio
, sonopy
, speechpy
, fitipy
, attrs
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "mycroft-precise";
  version = "2020-02-14"; # TODO 0.3.0

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = "mycroft-precise";
    rev = "db4e3f52b49e0b74b9ee6a4c969c3c45cc98dc7f";
    sha256 = "1gfc949ms889aw3ingfhnmkxapyb6h5488c23hh543jkkg7rh0m3";
  };

  patches = [
    (fetchpatch {
      name = "tf-2.x";
      url = "https://github.com/MycroftAI/mycroft-precise/pull/141.patch";
      sha256 = "07irlfipnia2fcyxg7cwlx42xvjbyq4h9fv1sbxpdl2mb1642f1w";
    })
  ];

  postPatch = ''
    sed -i "s/'tensorflow-gpu[^']*'/'tensorflow'/" setup.py
    sed -i 's/typing/typing; python_version<"3.5"/' setup.py # not for newer python
  '';

  # https://github.com/MycroftAI/mycroft-precise/pull/141
  propagatedBuildInputs = [
    tensorflow_2
    prettyparse
    Keras
    wavio
    pyache
    precise-runner
    pyaudio
    sonopy
    speechpy
    fitipy
    attrs
    numpy

    alsaLib
    libpulseaudio
  ];

  checkInputs = [
    pytest
  ];

  meta = with stdenv.lib; {
    description = "A lightweight, simple-to-use, RNN wake word listener";
    homepage = "https://github.com/MycroftAI/mycroft-precise";
    license = licenses.asl20;
    changelog = "https://github.com/MycroftAI/mycroft-precise/releases/tag/v${version}";
    platforms = platforms.linux;
    maintainers = with maintainers; [ timokau ];
  };
}
