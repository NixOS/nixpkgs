{
  lib,
  buildPythonPackage,
  fetchPypi,
  morphys,
  pytestCheckHook,
  python-baseconv,
  pythonOlder,
  six,
}:
buildPythonPackage rec {
  pname = "py-multibase";
  version = "1.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0oog78u2Huwo9VgnoL8ynHzqgP/9kzrsrqauhDEmf+Q=";
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

  meta = with lib; {
    description = "Module for distinguishing base encodings and other simple string encodings";
    homepage = "https://github.com/multiformats/py-multibase";
    changelog = "https://github.com/multiformats/py-multibase/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
