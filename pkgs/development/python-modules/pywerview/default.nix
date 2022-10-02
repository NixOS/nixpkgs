{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, gssapi
, impacket
, ldap3
, lxml
, pyasn1
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pywerview";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "the-useless-one";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nrPhyBHW13dkXFC5YJfrkiztAxMw4KuEif0zCdjQEq0=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    gssapi
    impacket
    ldap3
    lxml
    pyasn1
  ];

  # Module has no tests
  doCheck = false;

  postPatch = ''
    # https://github.com/the-useless-one/pywerview/pull/51
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4"
  '';

  pythonImportsCheck = [
    "pywerview"
  ];

  meta = with lib; {
    description = "Module for PowerSploit's PowerView support";
    homepage = "https://github.com/the-useless-one/pywerview";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
