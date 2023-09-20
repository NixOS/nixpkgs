{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, packaging
, poetry-core
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "newversion";
  version = "1.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vemel";
    repo = pname;
    rev = version;
    hash = "sha256-27HWMzSzyAbiOW7OUhlupRWIVJG6DrpXObXmxlCsmxU=";
  };

  patches = [
    # https://github.com/vemel/newversion/pull/9
    (fetchpatch {
      name = "remove-setuptools-dependency.patch";
      url = "https://github.com/vemel/newversion/commit/b50562671029dd6834bc7a8ad0dd3f9e0fbdfc1d.patch";
      hash = "sha256-6dXVQ9Hk0/EfSwPbW19ZV8MAFcSx+ZRO5G94kbh23GM=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "newversion"
  ];

  meta = with lib; {
    description = "PEP 440 version manager";
    homepage = "https://github.com/vemel/newversion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
