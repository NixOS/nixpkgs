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
  version = "2025.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    tag = "v${version}";
    sha256 = "sha256-WBMt5jDPCBmTgVdYDN662uU2HVjB1U3GYJwn0P56WsI=";
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
