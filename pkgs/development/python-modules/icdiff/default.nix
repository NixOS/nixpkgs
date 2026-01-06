{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonAtLeast,
  writableTmpDirAsHomeHook,
  pkgs,
}:
let
  inherit (pkgs) bash git less;
in

buildPythonPackage rec {
  pname = "icdiff";
  version = "2.0.8-unstable-2025-11-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    rev = "ee4643ae3976ca023dab534eb59b911f16f762ac";
    hash = "sha256-XV88WjZDc2NSQ5CEahr8KXLXrBACvIWOavMUPeoPGOw=";
    leaveDotGit = true;
  };

  patches = [ ./0001-Don-t-test-black-or-flake8.patch ];

  postPatch = ''
    substituteInPlace test.sh \
      --replace-fail "check_gold 1 gold-exclude.txt" "# check_gold 1 gold-exclude.txt" \
      --replace-fail "check_gold 1 gold-strip-cr-off.txt" "# check_gold 1 gold-strip-cr-off.txt" \
      --replace-fail "check_gold 1 gold-strip-cr-on.txt" "# check_gold 1 gold-strip-cr-on.txt" \
      --replace-fail "check_gold 1 gold-no-cr-indent" "# check_gold 1 gold-no-cr-indent"
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "icdiff" ];

  nativeCheckInputs = [
    bash
    git
    less
    writableTmpDirAsHomeHook
  ];

  # Odd behavior in the sandbox
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck

    patchShebangs test.sh
    ./test.sh ${python.interpreter}

    runHook postCheck
  '';

  meta = {
    description = "Improved colorized diff";
    homepage = "https://github.com/jeffkaufman/icdiff";
    changelog = "https://github.com/jeffkaufman/icdiff/releases/tag/release-${version}/CHANGELOG.md";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
