{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pykerberos,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "pure-sasl";
  version = "0.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "thobbs";
    repo = "pure-sasl";
    tag = version;
    hash = "sha256-AHoZ3QZLr0JLE8+a2zkB06v2wRknxhgm/tcEPXaJX/U=";
  };

  postPatch = ''
    substituteInPlace tests/unit/test_mechanism.py \
      --replace 'from mock import patch' 'from unittest.mock import patch'
  '';

  pythonImportsCheck = [ "puresasl" ];

  nativeCheckInputs = [
    pykerberos
    pytestCheckHook
    six
  ];

  meta = {
    description = "Reasonably high-level SASL client written in pure Python";
    homepage = "http://github.com/thobbs/pure-sasl";
    changelog = "https://github.com/thobbs/pure-sasl/blob/0.6.2/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
