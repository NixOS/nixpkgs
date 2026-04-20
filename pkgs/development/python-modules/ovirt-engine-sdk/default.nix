{
  buildPythonPackage,
  fetchPypi,
  lib,
  libxml2,
  pycurl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ovirt-engine-sdk";
  version = "4.6.3";
  src = fetchPypi {
    pname = "ovirt_engine_sdk_python";
    inherit version;
    hash = "sha256-nPAkJ5K4kQy3st7MOIbbLM/XeVB+Rqwc4qUlcwdf098=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  buildInputs = [ libxml2 ];

  dependencies = [ pycurl ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "/usr/include/libxml2" "${libxml2.dev}/include/libxml2" \
      --replace-fail "libraries=[" "library_dirs=['${libxml2.out}/lib'], libraries=["
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "ovirtsdk4" ];

  meta = {
    description = "The oVirt Python SDK is a Python package that simplifies access to the oVirt Engine API";
    downloadPage = "https://pypi.org/project/ovirt-engine-sdk-python/";
    homepage = "https://github.com/oVirt/ovirt-engine-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sulfiore ];
  };
}
