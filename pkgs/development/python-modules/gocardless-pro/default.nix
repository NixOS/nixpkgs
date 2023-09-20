{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, six
, pytestCheckHook
, responses
, nose
}:

buildPythonPackage rec {
  pname = "gocardless-pro";
  version = "1.46.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gocardless";
    repo = "gocardless-pro-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-tfaV/pohDu7IIzDa9B3GpnzOs6U+MVoFM3YZ0ErC7zQ=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  pythonImportsCheck = [ "gocardless_pro" ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
    nose
  ];

  meta = with lib; {
    description = "A client library for the GoCardless Pro API";
    homepage = "https://github.com/gocardless/gocardless-pro-python";
    changelog = "https://github.com/gocardless/gocardless-pro-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

