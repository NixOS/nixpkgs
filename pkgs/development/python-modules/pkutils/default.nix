{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nose3,
  pythonOlder,
  pythonRelaxDepsHook,
  semver,
}:

buildPythonPackage rec {
  pname = "pkutils";
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "reubano";
    repo = "pkutils";
    rev = "refs/tags/v${version}";
    hash = "sha256-AK+xX+LPz6IVLZedsqMUm7G28ue0s3pXgIzxS4EHHLE=";
  };

  pythonRelaxDeps = [ "semver" ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [ semver ];

  nativeCheckInputs = [ nose3 ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  pythonImportsCheck = [ "pkutils" ];

  meta = with lib; {
    description = "A Python packaging utility library";
    homepage = "https://github.com/reubano/pkutils/";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
