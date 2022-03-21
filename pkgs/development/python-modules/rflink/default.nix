{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, async-timeout
, docopt
, pyserial
, pyserial-asyncio
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rflink";
  version = "0.0.62";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aequitas";
    repo = "python-rflink";
    rev = version;
    sha256 = "sha256-dEzkYE8xtUzvdsnPaSiQR8960WLOEcr/QhwDiQlobcs=";
  };

  propagatedBuildInputs = [
    async-timeout
    docopt
    pyserial
    pyserial-asyncio
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=version_from_git()" "version='${version}'"
  '';

  pythonImportsCheck = [
    "rflink.protocol"
  ];

  meta = with lib; {
    description = "Library and CLI tools for interacting with RFlink 433MHz transceiver";
    homepage = "https://github.com/aequitas/python-rflink";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
