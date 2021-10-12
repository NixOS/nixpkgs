{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, dask
, holoviews
, hvplot
, fsspec
, jinja2
, msgpack
, msgpack-numpy
, numpy
, pandas
, panel
, intake-parquet
, pyarrow
, pytestCheckHook
, pythonOlder
, python-snappy
, requests
, ruamel_yaml
, six
, tornado
}:

buildPythonPackage rec {
  pname = "intake";
  version = "0.6.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f64543353f30d9440b953984f78b7a0954e5756d70c64243609d307ba488014f";
  };

  propagatedBuildInputs = [
    appdirs
    dask
    holoviews
    hvplot
    jinja2
    msgpack-numpy
    msgpack
    numpy
    pandas
    panel
    python-snappy
    requests
    ruamel_yaml
    six
    tornado
  ];

  checkInputs = [
    fsspec
    intake-parquet
    pyarrow
    pytestCheckHook
  ];

  postPatch = ''
    # Is in setup_requires but not used in setup.py...
    substituteInPlace setup.py --replace "'pytest-runner'" ""
  '';

  # test_discover requires driver_with_entrypoints-0.1.dist-info, which is not included in tarball
  # test_filtered_compressed_cache requires calvert_uk_filter.tar.gz, which is not included in tarball
  preCheck = ''
    HOME=$TMPDIR
    PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # disable tests which touch network and are broken
    "test_discover"
    "test_filtered_compressed_cache"
    "test_get_dir"
    "test_remote_cat"
    "http"
    "test_read_pattern"
    "test_remote_arr"
  ];

  meta = with lib; {
    description = "Data load and catalog system";
    homepage = "https://github.com/ContinuumIO/intake";
    license = licenses.bsd2;
    maintainers = with maintainers; [ costrouc ];
  };
}
