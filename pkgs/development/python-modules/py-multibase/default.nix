{
  lib,
  buildPythonPackage,
  fetchPypi,
  morphys,
  pytestCheckHook,
  python-baseconv,
  six,
}:
buildPythonPackage rec {
  pname = "py-multibase";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WMGiZBlfoa4p6nB8b8gZZEb0vbkuD5oPEx4PKAsjiDk=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "[pytest]" "" \
      --replace "python_classes = *TestCase" ""
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    morphys
    python-baseconv
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multibase" ];

  meta = {
    description = "Module for distinguishing base encodings and other simple string encodings";
    homepage = "https://github.com/multiformats/py-multibase";
    changelog = "https://github.com/multiformats/py-multibase/blob/v${version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
}
