{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  icontract,
  pytestCheckHook,
  replaceVars,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pylddwrap";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Parquery";
    repo = "pylddwrap";
    rev = "v${version}";
    hash = "sha256-Gm82VRu8GP52BohQzpMUJfh6q2tiUA2GJWOcG7ymGgg=";
  };

  patches = [
    (replaceVars ./replace_env_with_placeholder.patch {
      ldd_bin = "${stdenv.cc.bintools.libc_bin}/bin/ldd";
    })
  ];

  # Upstream adds some plain text files direct to the package's root directory
  # https://github.com/Parquery/pylddwrap/blob/master/setup.py#L71
  postInstall = ''
    rm -f $out/{LICENSE,README.rst,requirements.txt}
  '';

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    icontract
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # uses mocked ldd from PATH, but we are patching the source to not look at PATH
  disabledTests = [
    "TestAgainstMockLdd"
    "TestMain"
  ];

  pythonImportsCheck = [ "lddwrap" ];

  meta = {
    description = "Python wrapper around ldd *nix utility to determine shared libraries of a program";
    mainProgram = "pylddwrap";
    homepage = "https://github.com/Parquery/pylddwrap";
    changelog = "https://github.com/Parquery/pylddwrap/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thiagokokada ];
    # should work in any Unix platform that uses glibc, except for darwin
    # since it has its own tool (`otool`)
    badPlatforms = lib.platforms.darwin;
  };
}
