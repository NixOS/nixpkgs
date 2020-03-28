{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, arrow
, nest-asyncio
, qiskit-terra
, requests
, requests_ntlm
, websockets
  # check inputs
, pytestCheckHook
, vcrpy
, pproxy
}:

buildPythonPackage rec {
  pname = "qiskit-ibmq-provider";
  version = "0.5.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    sha256 = "1jhgsfspmry0qk7jkcryn4225j2azys3rm99agk6mh0jzwrvx4am";
  };

  propagatedBuildInputs = [
    arrow
    nest-asyncio
    qiskit-terra
    requests
    requests_ntlm
    websockets
  ];

  # websockets seems to be pinned b/c in v8+ it drops py3.5 support. Not an issue here (usually py3.7+, and disabled for older py3.6)
  prePatch = ''
    substituteInPlace requirements.txt --replace "websockets>=7,<8" "websockets"
    substituteInPlace setup.py --replace "websockets>=7,<8" "websockets"
  '';

  # Most tests require credentials to run on IBMQ
  checkInputs = [ pytestCheckHook vcrpy pproxy ];
  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "qiskit.providers.ibmq" ];
  disabledTests = [ "test_old_api_url" "test_non_auth_url" "test_non_auth_url_with_hub" ];  # tests require internet connection
  # skip tests that require IBMQ credentials, vs failing.
  preCheck = ''
    pushd /build/source  # run pytest from /build vs $out
    substituteInPlace test/decorators.py --replace "Exception('Could not locate valid credentials.')" "SkipTest('No IBMQ Credentials provided for tests')"
  '';
  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "Qiskit provider for accessing the quantum devices and simulators at IBMQ";
    homepage = "https://github.com/Qiskit/qiskit-ibmq-provider";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
