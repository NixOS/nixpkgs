{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastcov";
  version = "1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RPGillespie6";
    repo = "fastcov";
    tag = "v${version}";
    hash = "sha256-frpX0b8jqKfsxQrts5XkOkjgKlmi7p1r/+Mu7Dl4mm8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = false;

  pythonImportsCheck = [ "fastcov" ];

  postInstall = ''
    install -Dm755 utils/fastcov_summary.py $out/bin/fastcov_summary
    install -Dm755 utils/fastcov_to_sonarqube.py $out/bin/fastcov_to_sonarqube
  '';

  meta = {
    description = "A parallelized gcov wrapper for generating intermediate coverage formats fast";
    longDescription = ''
      The goal of fastcov is to generate code coverage intermediate formats as fast as possible,
      even for large projects with hundreds of gcda objects. The intermediate formats may then
      be consumed by a report generator such as lcov's genhtml, or a dedicated front end such
      as coveralls, codecov, etc. fastcov was originally designed to be a drop-in replacement
      for lcov (application coverage only, not kernel coverage).
    '';
    homepage = "https://github.com/RPGillespie6/fastcov";
    changelog = "https://github.com/RPGillespie6/fastcov/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "fastcov";
  };
}
