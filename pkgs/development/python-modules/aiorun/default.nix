{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, fetchpatch
, flit-core
, pygments
, pytestCheckHook
, uvloop
}:

buildPythonPackage rec {
  pname = "aiorun";
  version = "2023.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3AGsT8IUNi5SZHBsBfd7akj8eQ+xb0mrR7ydIr3T8gs=";
  };

  patches = [
    # Raise flit-core version constrains
    (fetchpatch { # https://github.com/cjrh/aiorun/pull/85
      url = "https://github.com/cjrh/aiorun/commit/a0c027ea331167712738e35ca70fefcd794e16d5.patch";
      hash = "sha256-M1rcrkdFcoFa3IncPnJaRhnXbelyk56QnMGtmgB6bvk=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
    uvloop
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "aiorun"
  ];

  meta = with lib; {
    description = "Boilerplate for asyncio applications";
    homepage = "https://github.com/cjrh/aiorun";
    changelog = "https://github.com/cjrh/aiorun/blob/v${version}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
