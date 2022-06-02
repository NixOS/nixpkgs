{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, jinja2
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "netutils";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rTSesG7XmIzu2DcJMVgZMlh0kRQ8jEB3t++rgf63Flw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    jinja2
    pytestCheckHook
    pyyaml
    toml
  ];

  patches = [
    # Switch to poetry-core, https://github.com/networktocode/netutils/pull/115
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/networktocode/netutils/commit/edc8b06686db4e5b4c8c4deb6d0effbc22177b31.patch";
      sha256 = "sha256-K5oSbtOJYeKbxzbaZQBXcl6LsHQAK8CxBLfkak15V6M=";
    })
  ];

  pythonImportsCheck = [
    "netutils"
  ];

  disabledTests = [
    # Tests require network access
    "test_is_fqdn_resolvable"
    "test_fqdn_to_ip"
    "test_tcp_ping"
    # Skip SPhinx test
    "test_sphinx_build"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Library that is a collection of objects for common network automation tasks";
    homepage = "https://github.com/networktocode/netutils";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
