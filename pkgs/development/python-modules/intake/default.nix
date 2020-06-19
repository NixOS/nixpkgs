{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, dask
, holoviews
, hvplot
, jinja2
, msgpack-numpy
, msgpack
, numpy
, pandas
, panel
, pyarrow
, python-snappy
, requests
, ruamel_yaml
, six
, tornado
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "intake";
  version = "0.6.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c284abeb74927a7366dcab6cefc010c4d050365b8af61c37326a2473a490a4e";
  };

  checkInputs = [ pyarrow pytest ];
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

  postPatch = ''
    # Is in setup_requires but not used in setup.py...
    substituteInPlace setup.py --replace "'pytest-runner'" ""
  '';

  # test_discover requires driver_with_entrypoints-0.1.dist-info, which is not included in tarball
  # test_filtered_compressed_cache requires calvert_uk_filter.tar.gz, which is not included in tarball
  checkPhase = ''
    PATH=$out/bin:$PATH HOME=$(mktemp -d) pytest -k "not test_discover and not test_filtered_compressed_cache"
  '';

  meta = with lib; {
    description = "Data load and catalog system";
    homepage = "https://github.com/ContinuumIO/intake";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
