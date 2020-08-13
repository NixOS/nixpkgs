{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, passlib
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.15.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "af97353076b8e5d271d91c64c8ca806e2157d11b7862c90ff6f0e23be0fc217d";
  };

  propagatedBuildInputs = [ passlib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/tlocke/pg8000";
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };

}
