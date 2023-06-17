{ lib
, asn1crypto
, buildPythonPackage
, dnspython
, dsinternals
, fetchFromGitHub
, impacket
, ldap3
, pyasn1
, pycryptodome
, pyopenssl
, pythonOlder
, requests_ntlm
}:

buildPythonPackage rec {
  pname = "certipy-ad";
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ly4k";
    repo = "Certipy";
    rev = "refs/tags/${version}";
    hash = "sha256-llLGr9IpuXQYIN2WaOkvfE2dAZb3PMVlNmketUpuyDI=";
  };

  postPatch = ''
    # pin does not apply because our ldap3 contains a patch to fix pyasn1 compability
    substituteInPlace setup.py \
      --replace "pyasn1==0.4.8" "pyasn1"
  '';

  propagatedBuildInputs = [
    asn1crypto
    dnspython
    dsinternals
    impacket
    pyopenssl
    ldap3
    pyasn1
    pycryptodome
    requests_ntlm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "certipy"
  ];

  meta = with lib; {
    description = "Library and CLI tool to enumerate and abuse misconfigurations in Active Directory Certificate Services";
    homepage = "https://github.com/ly4k/Certipy";
    changelog = "https://github.com/ly4k/Certipy/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
