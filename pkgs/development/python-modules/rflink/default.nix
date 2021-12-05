{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, async-timeout, docopt
, pyserial, pyserial-asyncio, setuptools, pytestCheckHook }:

buildPythonPackage rec {
  pname = "rflink";
  version = "0.0.58";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aequitas";
    repo = "python-rflink";
    rev = version;
    sha256 = "1zab55lsw419gg0jfrl69ap6128vbi3wdmg5z7qin65ijpjdhasc";
  };

  propagatedBuildInputs =
    [ async-timeout docopt pyserial pyserial-asyncio setuptools ];

  checkInputs = [ pytestCheckHook ];

  patches = [
    # Remove loop, https://github.com/aequitas/python-rflink/pull/61
    (fetchpatch {
      name = "remove-loop.patch";
      url =
        "https://github.com/aequitas/python-rflink/commit/777e19b5bde3398df5b8f142896c34a01ae18d52.patch";
      sha256 = "sJmihxY3fNSfZVFhkvQ/+9gysQup/1jklKDMyDDLOs8=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=version_from_git()" "version='${version}'"
  '';

  pythonImportsCheck = [ "rflink.protocol" ];

  meta = with lib; {
    description =
      "Library and CLI tools for interacting with RFlink 433MHz transceiver";
    homepage = "https://github.com/aequitas/python-rflink";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
