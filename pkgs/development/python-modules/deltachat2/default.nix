{ lib
, fetchPypi
, libdeltachat
, buildPythonPackage
, deltachat-rpc-server
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "deltachat2";
  version = "0.6.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gsvDBoT1xnO/V4YyannIF4Md+fIcsM5mXu6295ZVATo=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    full = [
      deltachat-rpc-server
    ];
  };

  pythonImportsCheck = [ "deltachat2" ];

  meta = with lib; {
    description = "Client library for Delta Chat core JSON-RPC interface";
    homepage = "https://github.com/adbenitez/deltachat2";
    license = licenses.mpl20;
    maintainers = libdeltachat.meta.maintainers;
    mainProgram = "deltachat2";
  };
}
