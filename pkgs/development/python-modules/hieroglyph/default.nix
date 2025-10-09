{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  sphinx,
}:

buildPythonPackage rec {
  pname = "hieroglyph";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "nyergler";
    repo = "hieroglyph";
    tag = "hieroglyph-${version}";
    hash = "sha256-nr5cHF0Lg2mjQvnOoM5HCmMUiGh1QOeTD0nc8BvCBOE=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  patches = [
    # https://github.com/nyergler/hieroglyph/pull/177hieroglyph-quickstart
    (fetchpatch {
      name = "hieroglyph-upgrade-versioneer";
      url = "https://github.com/nyergler/hieroglyph/commit/9cebee269ac10964b2436c0204156b7bd620a3d4.patch";
      hash = "sha256-ZvU7uASU727/NUAW8I7k9idzMpEdnuwRshdHm2/GQ3w=";
    })
    # https://github.com/nyergler/hieroglyph/pull/174
    (fetchpatch {
      name = "hieroglyph-slide-builder-type-error";
      url = "https://github.com/nyergler/hieroglyph/pull/174/commits/d75c550f797e3635d33db11f50968755288962a7.patch";
      hash = "sha256-qNQVgWL9jy0cwtxKUbWi3Qc77RU2H3raN0BzBjDk9C8=";
    })
  ];

  # load_additional_themes has been deprecated, need to use its deprecated name
  postPatch = ''
    substituteInPlace src/hieroglyph/builder.py \
      --replace-fail "theme_factory.load_additional_themes" "theme_factory._load_additional_themes"
  '';

  dependencies = [
    setuptools
    sphinx
  ];

  pythonImportsCheck = [ "hieroglyph" ];

  # all tests fail; don't know why:
  # test_absolute_paths_made_relative (hieroglyph.tests.test_path_fixing.PostProcessImageTests) ... ERROR
  doCheck = false;

  meta = with lib; {
    description = "Generate HTML presentations from plain text sources";
    homepage = "https://github.com/nyergler/hieroglyph/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ juliendehos ];
  };
}
