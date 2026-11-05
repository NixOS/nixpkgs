{
  lib,
  buildPythonPackage,
  fetchzip,
  setuptools,
  pygit2,
  git-bug,
  pytestCheckHook,
  typing-extensions,
  gitMinimal,
  cacert,
}:

buildPythonPackage rec {
  pname = "ezgb";
  version = "0.2.1";
  pyproject = true;

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/ezgb/ezgb.git/snapshot/${version}.tar.gz";
    hash = "sha256-qjVWX3tU+2VuuW70PGSKGpIINHI1wxHz/iRV26chD7E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pygit2
    git-bug
  ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
    git-bug
    gitMinimal
  ];

  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  meta = {
    description = "Python library for listing, creating and updating git-bug issues without an external database";
    homepage = "https://git.kernel.org/pub/scm/utils/ezgb/ezgb.git";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ feyorsh ];
  };
}
