{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchFromGitHub,
  pudb,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "recline";
  version = "2024.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    tag = "v${version}";
    sha256 = "sha256-Qc4oofuhSZ2S5zuCY9Ce9ISldYI3MDUJXFc8VcXdLIU=";
  };

  patches = [
    # based on https://github.com/NetApp/recline/pull/21
    ./devendor.patch
  ];

  postPatch = ''
    rm -r recline/vendor/argcomplete
  '';

  build-system = [ setuptools ];

  dependencies = [ argcomplete ];

  nativeCheckInputs = [
    pudb
    pytestCheckHook
  ];

  pythonImportsCheck = [ "recline" ];

  meta = with lib; {
    description = "This library helps you quickly implement an interactive command-based application";
    homepage = "https://github.com/NetApp/recline";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
