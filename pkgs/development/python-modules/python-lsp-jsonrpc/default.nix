{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, ujson
}:

buildPythonPackage rec {
  pname = "python-lsp-jsonrpc";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h4bs8s4axcm0p02v59amz9sq3nr4zhzdgwq7iaw6awl27v1hd0i";
  };

  propagatedBuildInputs = [
    ujson
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report html --cov-report term --junitxml=pytest.xml" "" \
      --replace "--cov pylsp_jsonrpc --cov test" ""
  '';

  pythonImportsCheck = [ "pylsp_jsonrpc" ];

  meta = with lib; {
    description = "Python server implementation of the JSON RPC 2.0 protocol.";
    homepage = "https://github.com/python-lsp/python-lsp-jsonrpc";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
