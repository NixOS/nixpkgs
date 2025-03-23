{
  lib,
  python3,
  fetchPypi,
  replaceVars,
  ffmpeg,
  installShellFiles,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1700";
  format = "setuptools";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XNIUkgEqRGrBtSxvfkSUSqxltZ6ZdkWoTc9kz4BD6Zw=";
  };

  patches = [
    (replaceVars ./ffmpeg-path.patch {
      ffmpeg = "${lib.getBin ffmpeg}/bin/ffmpeg";
      ffprobe = "${lib.getBin ffmpeg}/bin/ffmpeg";
      version = lib.getVersion ffmpeg;
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd you-get \
      --zsh contrib/completion/_you-get \
      --fish contrib/completion/you-get.fish \
      --bash contrib/completion/you-get-completion.bash
  '';

  pythonImportsCheck = [
    "you_get"
  ];

  meta = with lib; {
    description = "Tiny command line utility to download media contents from the web";
    homepage = "https://you-get.org";
    changelog = "https://github.com/soimort/you-get/raw/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
    mainProgram = "you-get";
  };
}
