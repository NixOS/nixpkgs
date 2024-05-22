{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, memcached
, mock
, pytestCheckHook

# for passthru.tests
, cachy
, cherrypy
, freeipa
, pymemcache
, ws4py
}:

buildPythonPackage rec {
  pname = "python-memcached";
  version = "1.62";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linsomniac";
    repo = "python-memcached";
    rev = version;
    hash = "sha256-Qko4Qr9WofeklU0uRRrSPrT8YaBYMCy0GP+TF7YZHLI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    memcached
    mock
    pytestCheckHook
  ];

  preCheck = ''
    memcached &
  '';

  postCheck = ''
    kill %%
  '';

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "memcache" ];

  passthru.tests = {
    inherit cachy cherrypy freeipa pymemcache ws4py;
  };

  meta = with lib; {
    description = "Pure python memcached client";
    homepage = "https://github.com/linsomniac/python-memcached";
    license = licenses.psfl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
