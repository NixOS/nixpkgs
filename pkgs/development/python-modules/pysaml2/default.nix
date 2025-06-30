{
  lib,
  buildPythonPackage,
  cryptography,
  defusedxml,
  fetchFromGitHub,
  fetchpatch,
  paste,
  poetry-core,
  pyasn1,
  pymongo,
  pyopenssl,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pytz,
  repoze-who,
  requests,
  responses,
  setuptools,
  replaceVars,
  xmlschema,
  xmlsec,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = "pysaml2";
    tag = "v${version}";
    hash = "sha256-2mvAXTruZqoSBUgfT2VEAnWQXVdviG0e49y7LPK5x00=";
  };

  patches = [
    (replaceVars ./hardcode-xmlsec1-path.patch {
      inherit xmlsec;
    })
    # Replaces usages of deprecated/removed pyopenssl APIs
    (fetchpatch {
      url = "https://github.com/IdentityPython/pysaml2/pull/977/commits/930a652a240c8cd1489429a7d70cf5fa7ef1606a.patch";
      hash = "sha256-kBNvGk5pwVmpW1wsIWVH9wapu6kjFavaTt4e3Llaw2c=";
    })
  ];

  postPatch = ''
    # Fix failing tests on systems with 32bit time_t
    sed -i 's/2999\(-.*T\)/2029\1/g' tests/*.xml
  '';

  pythonRelaxDeps = [ "xmlschema" ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cryptography
    defusedxml
    pyopenssl
    python-dateutil
    pytz
    requests
    setuptools
    xmlschema
  ];

  optional-dependencies = {
    s2repoze = [
      paste
      repoze-who
      zope-interface
    ];
  };

  nativeCheckInputs = [
    pyasn1
    pymongo
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # Disabled tests try to access the network
    "test_load_extern_incommon"
    "test_load_remote_encoding"
    "test_load_external"
    "test_conf_syslog"

    # Broken XML schema check in 7.5.2
    "test_namespace_processing"
  ];

  pythonImportsCheck = [ "saml2" ];

  meta = with lib; {
    description = "Python implementation of SAML Version 2 Standard";
    homepage = "https://github.com/IdentityPython/pysaml2";
    changelog = "https://github.com/IdentityPython/pysaml2/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
