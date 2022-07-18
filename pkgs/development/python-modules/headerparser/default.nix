{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "headerparser";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KJJt85iC/4oBoIelB2zUJVyHSppFem/22v6F30P5nYM=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--cov=headerparser" "" \
      --replace "--no-cov-on-fail" "" \
      --replace "--flakes" ""
  '';

  pythonImportsCheck = [
    "headerparser"
  ];

  meta = with lib; {
    description = "Module to parse key-value pairs in the style of RFC 822 (e-mail) headers";
    homepage = "https://github.com/jwodder/headerparser";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ayazhafiz ];
  };
}
