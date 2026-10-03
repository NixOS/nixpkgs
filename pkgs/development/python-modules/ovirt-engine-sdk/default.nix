{
  buildPythonPackage,
  fetchPypi,
  lib,
  libxml2,
  pycurl,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ovirt-engine-sdk";
  version = "4.6.3";
  pyproject = true;

  src = fetchPypi {
    pname = "ovirt_engine_sdk_python";
    inherit version;
    hash = "sha256-nPAkJ5K4kQy3st7MOIbbLM/XeVB+Rqwc4qUlcwdf098=";
  };

  build-system = [ setuptools ];

  buildInputs = [ libxml2 ];

  dependencies = [ pycurl ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "/usr/include/libxml2" "${libxml2.dev}/include/libxml2" \
      --replace-fail "libraries=[" "library_dirs=['${libxml2.out}/lib'], libraries=["
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # examples/test_connection.py requires a real oVirt engine
    "--ignore=examples"
    # these tests fail at collection due to a missing TestServer mock
    "--ignore=tests/test_cluster_service.py"
    "--ignore=tests/test_connection_create.py"
    "--ignore=tests/test_connection_error.py"
    "--ignore=tests/test_datacenter_service.py"
    "--ignore=tests/test_invalid_authentication.py"
    "--ignore=tests/test_iscsi_discover.py"
    "--ignore=tests/test_setupnetworks.py"
    "--ignore=tests/test_storage_domain_service.py"
    "--ignore=tests/test_vm_service.py"
  ];

  pythonImportsCheck = [ "ovirtsdk4" ];

  meta = {
    description = "The oVirt Python SDK is a Python package that simplifies access to the oVirt Engine API";
    downloadPage = "https://pypi.org/project/ovirt-engine-sdk-python/";
    homepage = "https://github.com/oVirt/ovirt-engine-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sulfiore ];
  };
}
