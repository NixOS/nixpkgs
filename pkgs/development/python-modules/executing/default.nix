{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, asttokens
}:

buildPythonPackage rec {
  pname = "executing";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hqx94h6l2wg9sljiaajfay2nr62sqa819w3bxrz8cdki1abdygv";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  # Tests appear to run fine (Ran 22 tests in 4.076s) with setuptoolsCheckPhase
  # but crash with pytestCheckHook
  checkInputs = [ asttokens ];

  meta = with lib; {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
