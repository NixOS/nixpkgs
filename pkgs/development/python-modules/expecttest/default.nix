{ buildPythonPackage
, fetchFromGitHub
, hypothesis
, lib
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "expecttest";
  version = "0.1.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ezyang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BFM0jFWXfH72n9XuFtU9URW8LWGPVJncXniBV5547W4=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ hypothesis pytestCheckHook ];

  pythonImportsCheck = [ "expecttest" ];

  meta = {
    maintainers = [ lib.maintainers.SomeoneSerge ];
    license = lib.licenses.mit;
    description = ''EZ Yang "golden" tests (testing against a reference implementation)'';
    homepage = "https://github.com/ezyang/expecttest";
    platforms = lib.platforms.unix;
  };
}
