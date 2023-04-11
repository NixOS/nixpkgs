{ lib
, buildPythonPackage
, certifi
, chardet
, fetchFromGitHub
, idna
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "frigidaire";
  version = "0.18.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bm1549";
    repo = pname;
    rev = "regs/tags/${version}";
    hash = "sha256-U2ixBtigY15RzMNIeUK71uNOndUepK2kE/CTFwl855w=";
  };

  postPatch = ''
    # https://github.com/bm1549/frigidaire/pull/13
    substituteInPlace setup.py \
      --replace "urllib3>==1.26.42" "urllib3" \
      --replace 'version = "SNAPSHOT"' 'version = "${version}"'
  '';

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    requests
    urllib3
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "frigidaire"
  ];

  meta = with lib; {
    description = "Python API for the Frigidaire devices";
    homepage = "https://github.com/bm1549/frigidaire";
    changelog = "https://github.com/bm1549/frigidaire/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
