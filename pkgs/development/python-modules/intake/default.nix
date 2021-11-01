{ lib
, appdirs
, bokeh
, buildPythonPackage
, dask
, entrypoints
, fetchFromGitHub
, fsspec
, holoviews
, hvplot
, intake-parquet
, jinja2
, msgpack
, msgpack-numpy
, numpy
, pandas
, panel
, pyarrow
, pytestCheckHook
, python-snappy
, pythonOlder
, pyyaml
, requests
, tornado
}:

buildPythonPackage rec {
  pname = "intake";
  version = "0.6.4";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "194cdd6lx92zcpkn3wgm490kxvw0c58ziix8hcihsr5ayfr1wdsl";
  };

  propagatedBuildInputs = [
    appdirs
    bokeh
    dask
    entrypoints
    fsspec
    holoviews
    hvplot
    jinja2
    msgpack
    msgpack-numpy
    numpy
    pandas
    panel
    pyarrow
    python-snappy
    pyyaml
    requests
    tornado
  ];

  checkInputs = [
    intake-parquet
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  # test_discover requires driver_with_entrypoints-0.1.dist-info, which is not included in tarball
  # test_filtered_compressed_cache requires calvert_uk_filter.tar.gz, which is not included in tarball
  preCheck = ''
    HOME=$TMPDIR
    PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # Disable tests which touch network and are broken
    "test_discover"
    "test_filtered_compressed_cache"
    "test_get_dir"
    "test_remote_cat"
    "http"
    "test_read_pattern"
    "test_remote_arr"
  ];

  pythonImportsCheck = [
    "intake"
  ];

  meta = with lib; {
    description = "Data load and catalog system";
    homepage = "https://github.com/ContinuumIO/intake";
    license = licenses.bsd2;
    maintainers = with maintainers; [ costrouc ];
  };
}
