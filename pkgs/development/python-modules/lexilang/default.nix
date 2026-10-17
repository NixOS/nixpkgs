{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "lexilang";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LexiLang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5/P9u2naTTyG5l3uhrinRIAekyOYn8OKLwb/VEON2Vc=";
  };

  build-system = [ setuptools ];

  # Upstream builds in CI:
  # https://github.com/LibreTranslate/LexiLang/blob/ba49108a736b9c077ea45cbe61d54fa635fe25d5/.github/workflows/publish.yml#L30-L31
  postInstall = ''
    ${lib.getExe python} -c "from lexilang.utils import compile_data; compile_data()"
    rm -f lexilang/data/.gitignore
    cp -r lexilang/data $out/${python.sitePackages}/lexilang/data
  '';

  pythonImportsCheck = [ "lexilang" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} test.py
    runHook postCheck
  '';

  meta = {
    description = "Simple, fast dictionary-based language detector for short texts";
    homepage = "https://github.com/LibreTranslate/LexiLang";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
