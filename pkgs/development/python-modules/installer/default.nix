{ lib
, buildPythonPackage
, fetchFromGitHub

# bootstrap
, flit-core
, python

# tests
, installer
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "installer";
  version = "0.7.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "installer";
    rev = "refs/tags/${version}";
    hash = "sha256-thHghU+1Alpay5r9Dc3v7ATRFfYKV8l9qR0nbGOOX/A=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    ls -lah
    mkdir -p $out/${python.sitePackages}
    cp -a src/installer* $out/${python.sitePackages}
    ${python.interpreter} -m compileall $out/${python.sitePackages}
    runHook postInstall
  '';

  pythonImportsCheck = [
    "installer"
  ];

  doCheck = false;

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  passthru.tests = {
    pytest = installer.overridePythonAttrs (oldAttrs: { doCheck = true; });
  };

  meta = with lib; {
    changelog = "https://github.com/pypa/installer/blob/${src.rev}/docs/changelog.md";
    homepage = "https://github.com/pradyunsg/installer";
    description = "A low-level library for installing a Python package from a wheel distribution";
    license = licenses.mit;
    maintainers = teams.python.members;
  };
}
