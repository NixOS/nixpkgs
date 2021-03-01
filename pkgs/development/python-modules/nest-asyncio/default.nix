{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "1.4.3";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    sha256 = "eaa09ef1353ebefae19162ad423eef7a12166bcc63866f8bff8f3635353cd9fa";
  };

  # tests not packaged with source dist as of 1.3.2/1.3.2, and
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
