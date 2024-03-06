{ lib
, buildPythonPackage
, dnspython
, fetchurl
, idna
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "email-validator";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  # Upstream has a bad habit of re-issuing release tarballs and
  # force-pushing over public release tags.
  # Archive new release tarballs at: https://web.archive.org/save
  src = fetchurl {
    url = "http://web.archive.org/web/20240306093519/https://github.com/JoshData/python-email-validator/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-BR/a+YJjvpr6UtzVC2vFkXCGVLa1mLR+SkCAIFpxf8E=";
  };

  propagatedBuildInputs = [
    dnspython
    idna
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # dns.resolver.NoResolverConfiguration: cannot open /etc/resolv.conf
    "tests/test_deliverability.py"
    "tests/test_main.py"
  ];

  pythonImportsCheck = [
    "email_validator"
  ];

  meta = with lib; {
    description = "Email syntax and deliverability validation library";
    homepage = "https://github.com/JoshData/python-email-validator";
    changelog = "https://github.com/JoshData/python-email-validator/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
  };
}
