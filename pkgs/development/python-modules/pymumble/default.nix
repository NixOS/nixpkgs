{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  opuslib,
  protobuf,
  pytestCheckHook,
  pycrypto,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pymumble";
  version = "1.6.1"; # Don't upgrade to 1.7, version was yanked
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "azlux";
    repo = "pymumble";
    rev = "refs/tags/${version}";
    hash = "sha256-+sT5pqdm4A2rrUcUUmvsH+iazg80+/go0zM1vr9oeuE=";
  };

  postPatch = ''
    # Changes all `library==x.y.z` statements to just `library`
    # So that we aren't constrained to a specific version
    sed -i 's/\(.*\)==.*/\1/' requirements.txt
  '';

  propagatedBuildInputs = [
    opuslib
    protobuf
  ];

  nativeCheckInputs = [
    pycrypto
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pymumble_py3"
    "pymumble_py3.constants"
  ];

  meta = with lib; {
    description = "Library to create mumble bots";
    homepage = "https://github.com/azlux/pymumble";
    changelog = "https://github.com/azlux/pymumble/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thelegy ];
  };
}
