{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  dos2unix,
  setuptools,
  pyasn1,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "ldap3";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cannatag";
    repo = "ldap3";
    tag = "v${version}";
    hash = "sha256-B+Sb6zMifkSKfaPYrXML5ugHGanbH5CPKeVdHshe3R4=";
  };

  prePatch = ''
    # patch fails to apply because of line endings
    dos2unix ldap3/utils/asn1.py
    substituteInPlace _version.json \
      --replace-fail '"version": "2.9",' '"version": "${version}",'
  '';

  patches = [
    # fix pyasn1 0.5.0 compatibility
    # https://github.com/cannatag/ldap3/pull/983
    (fetchpatch {
      url = "https://github.com/cannatag/ldap3/commit/ca689f4893b944806f90e9d3be2a746ee3c502e4.patch";
      hash = "sha256-A8qI0t1OV3bkKaSdhVWHFBC9MoSkWynqxpgznV+5gh8=";
    })
  ];

  nativeBuildInputs = [ dos2unix ];

  build-system = [ setuptools ];

  dependencies = [ pyasn1 ];

  nativeCheckInputs = [ unittestCheckHook ];

  enabledTestPaths = [ "test/" ];

  preCheck = ''
    export SERVER=NONE
  '';

  meta = with lib; {
    homepage = "https://github.com/cannatag/ldap3";
    description = "Strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
