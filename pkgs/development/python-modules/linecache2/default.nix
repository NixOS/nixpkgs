{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
}:

buildPythonPackage rec {
  pname = "linecache2";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b26ff4e7110db76eeb6f5a7b64a82623839d595c2038eeda662f2a2db78e97c";
  };

  buildInputs = [ pbr ];

  # circular dependencies for tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A backport of linecache to older supported Pythons";
    homepage = "https://github.com/testing-cabal/linecache2";
    license = licenses.psfl;
    maintainers = [ maintainers.costrouc ];
  };
}
