{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbr,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "git-url-parse";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coala";
    repo = "git-url-parse";
    rev = version;
    hash = "sha256-+0V/C3wE02ppdDGn7iqdvmgsUwTR7THUakUilvkzoYg=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov giturlparse --cov-report term-missing" ""
  '';

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  env.PBR_VERSION = version;

  propagatedBuildInputs = [ pbr ];

  pythonImportsCheck = [ "giturlparse" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A simple GIT URL parser";
    homepage = "https://github.com/coala/git-url-parse";
    changelog = "https://github.com/coala/git-url-parse/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
