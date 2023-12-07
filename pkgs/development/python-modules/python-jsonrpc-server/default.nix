{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytestCheckHook, mock, pytest-cov, coverage
, future, futures ? null, ujson}:

buildPythonPackage rec {
  pname = "python-jsonrpc-server";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-jsonrpc-server";
    rev = version;
    sha256 = "0pcf50qvcxqnz3db58whqd8z89cdph19pfs1whgfm0zmwbwk0lw6";
  };

  postPatch = ''
    sed -i "s/version=versioneer.get_version(),/version=\"$version\",/g" setup.py
  '';

  nativeCheckInputs = [
    pytestCheckHook mock pytest-cov coverage
  ];

  propagatedBuildInputs = [ future ujson ]
    ++ lib.optional (pythonOlder "3.2") futures;

  meta = with lib; {
    homepage = "https://github.com/palantir/python-jsonrpc-server";
    description = "A Python 2 and 3 asynchronous JSON RPC server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
