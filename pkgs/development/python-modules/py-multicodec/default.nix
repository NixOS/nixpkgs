{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-runner
, pytestCheckHook
, pythonOlder
, morphys
, six
, varint
}:

buildPythonPackage rec {
  pname = "py-multicodec";
  version = "0.2.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2aK+bfhqCMqSO+mtrHIfNQmQpQHpwd7yHseI/3O7Sp4=";
  };

  # Error when not substituting:
  # Failed: [pytest] section in setup.cfg files is no longer supported, change to [tool:pytest] instead.
  postPatch = ''
    substituteInPlace setup.cfg --replace "[pytest]" "[tool:pytest]"
  '';

  nativeBuildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    varint
    six
    morphys
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "multicodec" ];

  meta = with lib; {
    description = "Compact self-describing codecs";
    homepage = "https://github.com/multiformats/py-multicodec";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
