{ stdenv
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  version = "2.4.0";
  pname = "humanize";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42ae7d54b398c01bd100847f6cb0fc9e381c21be8ad3f8e2929135e48dbff026";
  };

  buildInputs = [ mock ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python humanize utilities";
    homepage = "https://github.com/jmoiron/humanize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };

}
