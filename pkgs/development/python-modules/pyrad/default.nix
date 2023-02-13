{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, lib
, poetry-core
, netaddr
, six
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pyrad";
  version = "2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = pname;
    rev = version;
    sha256 = "sha256-oqgkE0xG/8cmLeRZdGoHkaHbjtByeJwzBJwEdxH8oNY=";
  };

  patches = [
    (fetchpatch {
      # Migrate to poetry-core
      url = "https://github.com/pyradius/pyrad/commit/a4b70067dd6269e14a2f9530d820390a8a454231.patch";
      hash = "sha256-1We9wrVY3Or3GLIKK6hZvEjVYv6JOaahgP9zOMvgErE=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    netaddr
    six
  ];

  preCheck = ''
    substituteInPlace tests/testServer.py \
      --replace "def testBind(self):" "def dontTestBind(self):" \
      --replace "def testBindv6(self):" "def dontTestBindv6(self):"
  '';

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "pyrad"
  ];

  meta = with lib; {
    description = "Python RADIUS Implementation";
    homepage = "https://github.com/pyradius/pyrad";
    license = licenses.bsd3;
    maintainers = with maintainers; [ globin ];
  };
}
