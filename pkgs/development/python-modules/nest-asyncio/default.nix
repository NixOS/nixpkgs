{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "1.5.7";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aoD3uY8k2Qg+0kYIl3wJ3WCNg/kczMJMnSy6bRDgHBA=";
  };

  # tests not packaged with source dist as of 1.3.2/1.3.2, and
  # can't check tests out of GitHub easily without specific commit IDs (no tagged releases)
  doCheck = false;
  pythonImportsCheck = [ "nest_asyncio" ];

  meta = with lib; {
    description = "Patch asyncio to allow nested event loops";
    homepage = "https://github.com/erdewit/nest_asyncio";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
