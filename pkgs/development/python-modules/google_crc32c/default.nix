{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "google-crc32c";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1biyzc2sfjb91b19b9axafzn5mr66vy31lbmfralgn7cnrhbjfcl";
  };

  doCheck = false;  # tests do not ship with pypi package; avoid building from source
  pythonImportsCheck = [ "google_crc32c" ];

  meta = with stdenv.lib; {
    description = "Python wrapper of the C library 'Google CRC32C'";
    homepage = "https://github.com/googleapis/python-crc32c";
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
