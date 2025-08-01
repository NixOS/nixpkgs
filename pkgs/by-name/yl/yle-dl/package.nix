{
  lib,
  fetchFromGitHub,
  rtmpdump,
  php,
  wget,
  python3Packages,
  ffmpeg,
  testers,
  yle-dl,
}:

python3Packages.buildPythonApplication rec {
  pname = "yle-dl";
  version = "20250316";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = "releases/${version}";
    hash = "sha256-8cJVaoZRKAR/mkRebpgMfwOWIdDySS8q6Dc2kanr4SE=";
  };

  pyproject = true;

  propagatedBuildInputs = with python3Packages; [
    attrs
    configargparse
    ffmpeg
    future
    lxml
    requests
  ];
  buildInputs = with python3Packages; [
    flit-core
  ];
  pythonPath = [
    rtmpdump
    php
    wget
  ];

  doCheck = false; # tests require network access
  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = yle-dl;
    command = "yle-dl -h";
  };

  meta = {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = "https://aajanki.github.io/yle-dl/";
    changelog = "https://github.com/aajanki/yle-dl/blob/${version}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dezgeg ];
    platforms = lib.platforms.unix;
    mainProgram = "yle-dl";
  };
}
