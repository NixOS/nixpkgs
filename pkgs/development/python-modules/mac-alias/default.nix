{ lib, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  version = "2.2.0";
  pname = "mac-alias";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0eb84a63f98bf54c2f9fbdc4de956a63e64eb8a4a124143a1c1f5a78326442f0";
  };

  # pypi package does not include tests;
  # tests anyway require admin privileges to succeed
  doCheck = false;
  pythonImportsCheck = [ "mac-alias" ];

  meta = with lib; {
    homepage = "https://github.com/al45tair/mac-alias";
    description = "Generate or read binary Alias and Bookmark records from Python code";
    longDescription = ''
      mac-alias lets you generate or read binary Alias and Bookmark records from Python code.

      While it is written in pure Python, some OS X specific code is required
      to generate a proper Alias or Bookmark record for a given file,
      so this module currently is not portable to other platforms.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
