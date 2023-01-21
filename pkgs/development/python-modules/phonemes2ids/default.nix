{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "phonemes2ids";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "phonemes2ids";
    rev = "refs/tags/v${version}";
    hash = "sha256-av8bdFoGjVhlfm/1SKR6+HWpEoLMcp+oR/+zE9VAeqA=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/phonemes2ids/releases/tag/v${version}";
    description = "Flexible tool for assigning integer ids to phonemes";
    homepage = "https://github.com/rhasspy/phonemes2ids";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
  };
}
