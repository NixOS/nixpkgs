{ lib
, buildPythonPackage
, fetchFromGitHub
, installShellFiles
, mock
, scripttest
, setuptools
, virtualenv
, wheel
, pretend
, pytest

# coupled downsteam dependencies
, pip-tools
}:

buildPythonPackage rec {
  pname = "pip";
  version = "23.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mUlzfYmq1FE3X1/2o7sYJzMgwHRI4ib4EMhpg83VvrI=";
  };

  postPatch = ''
    # Remove vendored Windows PE binaries
    # Note: These are unused but make the package unreproducible.
    find -type f -name '*.exe' -delete
  '';

  nativeBuildInputs = [
    installShellFiles
    setuptools
    wheel
  ];

  nativeCheckInputs = [ mock scripttest virtualenv pretend pytest ];

  # Pip wants pytest, but tests are not distributed
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd pip \
      --bash <($out/bin/pip completion --bash) \
      --fish <($out/bin/pip completion --fish) \
      --zsh <($out/bin/pip completion --zsh)
  '';

  passthru.tests = { inherit pip-tools; };

  meta = {
    description = "The PyPA recommended tool for installing Python packages";
    license = with lib.licenses; [ mit ];
    homepage = "https://pip.pypa.io/";
    changelog = "https://pip.pypa.io/en/stable/news/#v${lib.replaceStrings [ "." ] [ "-" ] version}";
  };
}
