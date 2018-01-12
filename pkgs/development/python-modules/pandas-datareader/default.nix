{ stdenv, lib, fetchPypi, python, buildPythonPackage, pandas, requests,
requests-ftp, requests-file, python-dateutil, pytz, numpy, urllib3, idna,
chardet, certifi, six }:

buildPythonPackage rec {
  pname = "pandas-datareader";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "1j8qzzpnk8h8annyz5a3iwx2yzw007i75fk9b0rz93151i4cl8vm";
  };

  propagatedBuildInputs = [
    pandas requests requests-ftp requests-file python-dateutil
    pytz numpy urllib3 idna chardet certifi six
  ];

  # The test fails with `ImportError: No module named tests`.
  doCheck = false;
  meta = {
    description = "Remote data access for pandas.";
    homepage = https://github.com/pydata/pandas-datareader;
    license = stdenv.lib.licenses.bsd;
  };
}
