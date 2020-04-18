{ stdenv
, buildPythonPackage
, fetchFromGitHub
, mock
, six
}:

buildPythonPackage rec {
  pname = "IMAPClient";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "mjs";
    repo = "imapclient";
    rev = version;
    sha256 = "1zc8qj8ify2zygbz255b6fcg7jhprswf008ccwjmbrnj08kh9l4x";
  };

  # fix test failing in python 36
  postPatch = ''
    substituteInPlace tests/test_imapclient.py \
      --replace "if sys.version_info >= (3, 7):" "if sys.version_info >= (3, 6, 4):"
  '';

  propagatedBuildInputs = [ six ];

  checkInputs = [ mock ];

  meta = with stdenv.lib; {
    homepage = "https://imapclient.readthedocs.io";
    description = "Easy-to-use, Pythonic and complete IMAP client library";
    license = licenses.bsd3;
    maintainers = [ maintainers.almac ];
  };
}
