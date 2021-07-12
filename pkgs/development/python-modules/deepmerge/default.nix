{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
, vcver
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deepmerge";
  version = "0.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zfl8rkw98vj7jdpb29ably50x46pq6pazhrkrczndf5jc97zzgn";
  };

  nativeBuildInputs = [
    setuptools-scm
    vcver
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "deepmerge" ];

  meta = with lib; {
    description = "A toolset to deeply merge python dictionaries.";
    homepage = "http://deepmerge.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
