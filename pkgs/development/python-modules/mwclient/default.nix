{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, requests
, requests-oauthlib
, responses
, six
}:

buildPythonPackage rec {
  version = "0.10.1";
  pname = "mwclient";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    rev = "v${version}";
    sha256 = "120snnsh9n5svfwkyj1w9jrxf99jnqm0jk282yypd3lpyca1l9hj";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov mwclient test" ""
  '';

  pythonImportsCheck = [
    "mwclient"
  ];

  meta = with lib; {
    description = "Python client library to the MediaWiki API";
    license = licenses.mit;
    homepage = "https://github.com/mwclient/mwclient";
    maintainers = with maintainers; [ ];
  };
}
