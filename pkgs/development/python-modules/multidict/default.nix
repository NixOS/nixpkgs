{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "6.0.4";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NmaQZJLvt2RTwOe5fyz0WbBoLnQCwEialUhJZdvB2kk=";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isClang [
    # error: incompatible pointer to integer conversion initializing 'int' with an expression of type 'void *'
    "-Wno-error=int-conversion"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multidict" ];

  meta = with lib; {
    changelog = "https://github.com/aio-libs/multidict/blob/v${version}/CHANGES.rst";
    description = "Multidict implementation";
    homepage = "https://github.com/aio-libs/multidict/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
