{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "1.2.3";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fznrg32rk6fmvpfdxwwhadh526gdjivmdifg2hiciil2gr8n1s3";
  };

  # tests not packaged with source dist as of 1.2.3/1.2.3, and
  # can't check tests out of GitHub easily without specific commit IDs (no tagged releases)
  doCheck = false;
  pythonImportsCheck = [ "nest_asyncio" ];

  meta = with lib; {
    description = "Patch asyncio to allow nested event loops";
    homepage = "https://github.com/erdewit/nest_asyncio";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ costrouc ];
  };
}
