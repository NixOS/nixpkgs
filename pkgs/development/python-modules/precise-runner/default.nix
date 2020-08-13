{ lib
, fetchPypi
, buildPythonPackage
, mycroft-precise
, pyaudio
}:

buildPythonPackage rec {
  pname = "precise-runner";
  inherit (mycroft-precise) version src;

  sourceRoot = "source/runner";

  propagatedBuildInputs = [
    pyaudio
  ];

  meta = with lib; {
    description = "Wrapper to use Mycroft Precise Wake Word Listener";
    homepage = "https://github.com/MycroftAI/mycroft-precise/blob/dev/runner";
    license = licenses.asl20;
    changelog = "https://github.com/MycroftAI/mycroft-precise/releases/tag/v${version}";
    platforms = platforms.linux;
    maintainers = with maintainers; [ timokau ];
  };
}
