{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cbd885n3sf4qg1dv3mk1ggr5ssk48yzrzssznr92dh53g04ly7g";
  };

  # tests not packaged with source dist as of 1.3.0/1.3.0, and
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
