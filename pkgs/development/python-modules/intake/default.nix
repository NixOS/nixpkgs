{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, dask
, holoviews
, jinja2
, msgpack-numpy
, msgpack-python
, numpy
, pandas
, python-snappy
, requests
, ruamel_yaml
, six
, tornado
, pytest
, pythonOlder
, isPy27
}:

buildPythonPackage rec {
  pname = "intake";
  version = "0.4.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fc1b7c2949c9b4200ecbbfdff17da126981a1d8d95ccb7b7bcca3e3dd849d5e";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    appdirs
    dask
    holoviews
    jinja2
    msgpack-numpy
    msgpack-python
    numpy
    pandas
    python-snappy
    requests
    ruamel_yaml
    six
    tornado
  ];

  checkPhase = ''
    # test_filtered_compressed_cache requires calvert_uk_filter.tar.gz, which is not included in tarball
    # test_which assumes python for executable name
    PATH=$out/bin:$PATH HOME=$(mktemp -d) pytest -k "not test_filtered_compressed_cache and not test_which"
  '';

  meta = with lib; {
    description = "Data load and catalog system";
    homepage = https://github.com/ContinuumIO/intake;
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
