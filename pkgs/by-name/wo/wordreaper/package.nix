{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "wordreaper";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nemorous";
    repo = "wordreaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pZpKL2FHnbuYCMkaVYqo3SuIUvbepgE39byYHcbPo3M=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    colorama
    beautifulsoup4
    requests
    tqdm
    psutil
    wordninja
  ];

  doCheck = false; # upstream has no tests

  postInstall = ''
    chmod +x $out/${python3Packages.python.sitePackages}/word_reaper/bin/*.bin
  '';

  meta = {
    description = "Scrape targeted wordlists for password cracking using CSS selectors";
    homepage = "https://github.com/Nemorous/wordreaper";
    changelog = "https://github.com/Nemorous/wordreaper/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.SamuelBozeman ];
    mainProgram = "wordreaper";
  };
})
