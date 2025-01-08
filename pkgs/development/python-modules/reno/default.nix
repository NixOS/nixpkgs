{
  buildPythonApplication,
  dulwich,
  docutils,
  lib,
  fetchFromGitHub,
  git,
  gnupg,
  pbr,
  pyyaml,
  setuptools,
  sphinx,
  stestr,
  testtools,
  testscenarios,
}:

buildPythonApplication rec {
  pname = "reno";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "reno";
    rev = "refs/tags/${version}";
    hash = "sha256-le9JtE0XODlYhTFsrjxFXG/Weshr+FyN4M4S3BMBLUE=";
  };

  env.PBR_VERSION = version;

  build-system = [
    setuptools
  ];

  dependencies = [
    dulwich
    pbr
    pyyaml
    setuptools
  ];

  nativeCheckInputs = [
    # Python packages
    docutils
    sphinx
    stestr
    testtools
    testscenarios

    # Required programs to run all tests
    git
    gnupg
  ];

  checkPhase = ''
    runHook preCheck
    export HOME=$(mktemp -d)
    stestr run -e <(echo "
      # Expects to be run from a git repository
      reno.tests.test_cache.TestCache.test_build_cache_db
      reno.tests.test_semver.TestSemVer.test_major_post_release
      reno.tests.test_semver.TestSemVer.test_major_working_and_post_release
      reno.tests.test_semver.TestSemVer.test_major_working_copy
      reno.tests.test_semver.TestSemVer.test_minor_post_release
      reno.tests.test_semver.TestSemVer.test_minor_working_and_post_release
      reno.tests.test_semver.TestSemVer.test_minor_working_copy
      reno.tests.test_semver.TestSemVer.test_patch_post_release
      reno.tests.test_semver.TestSemVer.test_patch_working_and_post_release
      reno.tests.test_semver.TestSemVer.test_patch_working_copy
      reno.tests.test_semver.TestSemVer.test_same
      reno.tests.test_semver.TestSemVer.test_same_with_note
    ")
    runHook postCheck
  '';

  pythonImportsCheck = [ "reno" ];

  postInstallCheck = ''
    $out/bin/reno -h
  '';

  meta = with lib; {
    description = "Release Notes Manager";
    mainProgram = "reno";
    homepage = "https://docs.openstack.org/reno/latest";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
