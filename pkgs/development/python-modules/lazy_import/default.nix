{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pytest-forked
, py
, python
, six }:

buildPythonPackage rec {
  pname = "lazy_import";
  version = "0.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gca9xj60qr3aprj9qdc66crr4r7hl8wzv6gc9y40nclazwawj91";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-forked
    py
  ];

  propagatedBuildInputs = [
    six
  ];

  preCheck = ''
    # avoid AttributeError: module 'py' has no attribute 'process'
    export PYTHONPATH=${py}/${python.sitePackages}:$PYTHONPATH
  '';

  pytestFlagsArray = [
    "--forked"
  ];

  meta = with lib; {
    description = "A set of functions that load modules, and related attributes, in a lazy fashion";
    homepage = "https://github.com/mnmelo/lazy_import";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
