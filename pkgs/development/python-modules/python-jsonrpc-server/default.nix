{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytest, mock, pytestcov, coverage
, future, futures, ujson, isPy38
, fetchpatch
}:

buildPythonPackage rec {
  pname = "python-jsonrpc-server";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-jsonrpc-server";
    rev = version;
    sha256 = "027sx5pv4i9a192kr00bjjcxxprh2xyr8q5372q8ghff3xryk9dd";
  };

  postPatch = ''
    sed -i 's/version=versioneer.get_version(),/version="${version}",/g' setup.py
    # https://github.com/palantir/python-jsonrpc-server/issues/36
    sed -iEe "s!'ujson.*\$!'ujson',!" setup.py
  '';

  checkInputs = [
    pytest mock pytestcov coverage
  ];

  checkPhase = ''
    pytest
  '';

  patches = [
    (fetchpatch {
      url = "https://github.com/palantir/python-jsonrpc-server/commit/0a04cc4e9d44233b1038b12d63cd3bd437c2374e.patch";
      sha256 = "177zdnp1808r2pg189bvzab44l8i2alsgv04kmrlhhnv40h66qyg";
    })
    (fetchpatch {
      url = "https://github.com/palantir/python-jsonrpc-server/commit/5af6e43d0c1fb9a6a29b96d38cfd6dbeec85d0ea.patch";
      sha256 = "1gx7lc1jxar1ngqqfkdn21s46y1mfnjf7ky2886ydk53nkaba91m";
    })
  ];

  propagatedBuildInputs = [ future ujson ]
    ++ stdenv.lib.optional (pythonOlder "3.2") futures;

  meta = with stdenv.lib; {
    homepage = "https://github.com/palantir/python-jsonrpc-server";
    description = "A Python 2 and 3 asynchronous JSON RPC server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
