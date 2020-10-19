{ lib, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "mac_alias";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f07926e9befcc4ab35212d19541fe0e4e4abd67a7641aa75252a3ffd8deae94";
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
