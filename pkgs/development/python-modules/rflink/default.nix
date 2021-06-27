{ lib
, buildPythonPackage
, fetchFromGitHub
, async-timeout
, docopt
, pyserial
, pyserial-asyncio
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rflink";
  version = "0.0.58";

  src = fetchFromGitHub {
    owner = "aequitas";
    repo = "python-rflink";
    rev = version;
    sha256 = "1zab55lsw419gg0jfrl69ap6128vbi3wdmg5z7qin65ijpjdhasc";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=version_from_git()" "version='${version}'"
  '';

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

  pythonImportsCheck = [ "rflink.protocol" ];

  meta = with lib; {
    description = "Library and CLI tools for interacting with RFlink 433MHz transceiver";
    homepage = "https://github.com/aequitas/python-rflink";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
