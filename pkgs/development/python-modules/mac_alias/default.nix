{ lib, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  version = "2.2.2";
  pname = "mac_alias";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yZxyjrUS6VXBHxpiA6D/qIg7JlSeiv5ogEAxql2oVrc=";
  };

  # pypi package does not include tests;
  # tests anyway require admin privileges to succeed
  doCheck = false;
  pythonImportsCheck = [ "mac_alias" ];

  meta = with lib; {
    homepage = "https://github.com/al45tair/mac_alias";
    description = "Generate or read binary Alias and Bookmark records from Python code";
    longDescription = ''
      mac_alias lets you generate or read binary Alias and Bookmark records from Python code.

      While it is written in pure Python, some OS X specific code is required
      to generate a proper Alias or Bookmark record for a given file,
      so this module currently is not portable to other platforms.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
