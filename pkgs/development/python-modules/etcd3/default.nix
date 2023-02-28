{ lib
, buildPythonPackage
, etcd
, fetchPypi
, grpcio
, hypothesis
, mock
, pifpaf
, protobuf
, pytestCheckHook
, tenacity
}:

buildPythonPackage rec {
  pname = "etcd3";
  version = "0.12.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iacEyzib8KAQofoFDOGTQtI79jcevaHCHP6P8+1IhyY=";
  };

  postPatch = ''
    # forces test requirements at install
    substituteInPlace setup.py \
      --replace "tests_require=test_requirements" ""
  '';

  propagatedBuildInputs = [
    grpcio
    protobuf
    tenacity
  ];

  # incompatible with our hypothesis version
  doCheck = false;

  nativeCheckInputs = [
    etcd
    hypothesis
    mock
    pifpaf
    pytestCheckHook
  ];

  preCheck = ''
    pifpaf -e PYTHON run etcd --cluster
  '';

  pythonImportsCheck = [ "etcd3" ];

  meta = with lib; {
    description = "Python client for the etcd3 API";
    homepage = "https://github.com/kragniz/python-etcd3";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
