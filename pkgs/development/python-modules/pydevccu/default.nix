{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydevccu";
  version = "0.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "sha256-/4sJ5T17nCcTjg1Me4zTlOEOkK1py9kl2YeLGv4X6us=";
  };

  postPatch = ''
    # Fix file name, https://github.com/danielperna84/pydevccu/pull/8
    mv pydevccu/paramset_descriptions/HmIP-STDH.json pydevccu/paramset_descriptions/HmIP-STHD.json
  '';

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pydevccu"
  ];

  meta = with lib; {
    description = "HomeMatic CCU XML-RPC Server with fake devices";
    homepage = "https://github.com/danielperna84/pydevccu";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
