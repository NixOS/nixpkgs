{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  morphys,
  pytestCheckHook,
  six,
  varint,
}:

buildPythonPackage rec {
  pname = "py-multicodec";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = "py-multicodec";
    tag = "v${version}";
    hash = "sha256-2aK+bfhqCMqSO+mtrHIfNQmQpQHpwd7yHseI/3O7Sp4=";
  };

  # Error when not substituting:
  # Failed: [pytest] section in setup.cfg files is no longer supported, change to [tool:pytest] instead.
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "[pytest]" "[tool:pytest]"
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    morphys
    six
    varint
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multicodec" ];

  meta = {
    description = "Compact self-describing codecs";
    homepage = "https://github.com/multiformats/py-multicodec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
