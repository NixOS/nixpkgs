{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, lib
, poetry-core
, netaddr
, six
, unittestCheckHook
, fetchPypi
}:
let
  netaddr_0_8_0 = netaddr.overridePythonAttrs (oldAttrs: rec {
    version = "0.8.0";

    src = fetchPypi {
      pname = "netaddr";
      inherit version;
      hash = "sha256-1sxXx6B7HZ0ukXqos2rozmHDW6P80bg8oxxaDuK1okM=";
    };
  });
in

buildPythonPackage rec {
  pname = "pyrad";
  version = "2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = pname;
    rev = version;
    hash = "sha256-oqgkE0xG/8cmLeRZdGoHkaHbjtByeJwzBJwEdxH8oNY=";
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
    netaddr_0_8_0
    six
  ];
  preCheck = ''
    substituteInPlace tests/testServer.py \
      --replace-warn "def testBind(self):" "def dontTestBind(self):" \
      --replace-warn "def testBindv6(self):" "def dontTestBindv6(self):" \

    # A lot of test methods have been deprecated since Python 3.1
    # and have been removed in Python 3.12.
    # https://docs.python.org/3/whatsnew/3.11.html#pending-removal-in-python-3-12
    substituteInPlace tests/*.py \
      --replace-quiet "self.failUnless"   "self.assertTrue" \
      --replace-quiet "self.failIf"       "self.assertFalse" \
      --replace-quiet "self.assertEquals" "self.assertEqual"
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
    maintainers = with maintainers; [ ];
  };
}
