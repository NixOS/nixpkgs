{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cpufeature";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "robbmcleod";
    repo = "cpufeature";
    tag = "v${version}";
    hash = "sha256-dp569Tp8E5/avQpYvhPNPgS/A+q2e/ie+7BR7h2Ip+I=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "cpufeature" ];

  preCheck = ''
    # Change into the test directory due to a relative resource path
    cd cpufeature
  '';

  meta = with lib; {
    description = "Python module for detection of CPU features";
    homepage = "https://github.com/robbmcleod/cpufeature";
    license = licenses.cc0;
    maintainers = with maintainers; [ fab ];
    platforms = [
      "x86_64-linux"
      "x86_64-windows"
    ];
  };
}
