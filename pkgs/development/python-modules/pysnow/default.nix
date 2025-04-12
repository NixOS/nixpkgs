{
  lib,
  brotli,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  httpretty,
  ijson,
  poetry-core,
  python-magic,
  pytz,
  six,
  pytestCheckHook,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "pysnow";
  version = "0.7.16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "rbw";
    repo = pname;
    rev = version;
    hash = "sha256-nKOPCkS2b3ObmBnk/7FTv4o4vwUX+tOtZI5OQQ4HSTY=";
  };

  pythonRelaxDeps = [ "requests-oauthlib" ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    brotli
    ijson
    python-magic
    pytz
    six
    requests-oauthlib
  ];

  nativeCheckInputs = [
    httpretty
    pytestCheckHook
  ];

  patches = [
    # Switch to peotry-core, https://github.com/rbw/pysnow/pull/183
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/rbw/pysnow/commit/f214a203432b329df5317f3a25b2c0d9b55a9029.patch";
      hash = "sha256-ViRR+9WStlaQwyrLGk/tMOUAcEMY+kB61ZEKGMQJ30o=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'ijson = "^2.5.1"' 'ijson = "*"' \
      --replace 'pytz = "^2019.3"' 'pytz = "*"' \
      --replace 'oauthlib = "^3.1.0"' 'oauthlib = "*"'

    # https://github.com/rbw/pysnow/pull/201 doesn't apply via fetchpatch, so we recreate it
    substituteInPlace tests/test_client.py tests/test_oauth_client.py tests/test_params_builder.py tests/test_resource.py \
      --replace-fail "self.assertEquals" "self.assertEqual"
  '';

  pythonImportsCheck = [ "pysnow" ];

  meta = with lib; {
    description = "ServiceNow HTTP client library written in Python";
    homepage = "https://github.com/rbw/pysnow";
    license = licenses.mit;
    maintainers = with maintainers; [ almac ];
  };
}
