{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  dahlia,
  ixia,
}:

buildPythonPackage rec {
  pname = "oddsprout";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "oddsprout";
    rev = "refs/tags/v${version}";
    hash = "sha256-BOUYq4yny3ScgzCzx2cpeK4e7nxxwTj8mJ42nr59mFA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    dahlia
    ixia
  ];

  patches = [
    # https://github.com/trag1c/oddsprout/pull/8
    (fetchpatch2 {
      name = "allow-periods-in-path.patch";
      url = "https://github.com/trag1c/oddsprout/commit/59713a797e7748d48f59f92397981c93a81f2c28.patch";
      hash = "sha256-GAIQQi5s4D6KbTSgmP2hlBizLATxtJ/hzpWqPX4O0U4=";
    })
  ];

  # has one test `test_main_recursion_error`
  # that has a very low (~1%) but nonzero chance to fail,
  # this is known upstream (https://github.com/trag1c/oddsprout/issues/5)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oddsprout" ];

  meta = with lib; {
    changelog = "https://github.com/trag1c/oddsprout/blob/${src.rev}/CHANGELOG.md";
    description = "Generate random JSON with no schemas involved";
    license = licenses.mit;
    homepage = "https://trag1c.github.io/oddsprout";
    maintainers = with maintainers; [
      itepastra
      sigmanificient
    ];
  };
}
