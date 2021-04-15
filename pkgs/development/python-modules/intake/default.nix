{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, dask
, holoviews
, hvplot
, jinja2
, msgpack
, msgpack-numpy
, numpy
, pandas
, panel
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
  version = "0.6.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0cab1d185a703acb38eecb9cff3edd5cc7004fe18a36d5e42a8f7fffc9cca1c";
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

  checkInputs = [ pyarrow pytestCheckHook ];

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
    # disable tests which touch network
    "test_discover"
    "test_filtered_compressed_cache"
    "test_get_dir"
    "test_remote_cat"
    "http"

    # broken test
    "test_read_pattern"
  ];

  meta = with lib; {
    description = "Data load and catalog system";
    homepage = "https://github.com/ContinuumIO/intake";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
