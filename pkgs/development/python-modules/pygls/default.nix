{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub
, mock, pytest, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "pygls";
  version = "0.9.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wfp4hjin1mb6nkzhpfh5v8q8rwvn9zh0mwwj4dlxkqx5lp272hl";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest==4.5.0" "pytest"
  '';

  checkInputs = [ mock pytest pytest-asyncio ];
  checkPhase = "pytest";

  meta = with stdenv.lib; {
    homepage = "https://github.com/openlawlibrary/pygls";
    description = "Pythonic generic implementation of the Language Server Protocol";
    license = licenses.asl20;
    maintainers = with maintainers; [ metadark ];
  };
}
