{ buildPythonPackage
, fetchFromGitHub
, hypothesis
, lib
, poetry
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "expecttest";
  version = "0.1.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ezyang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5CnpVFSbf3FcAa06Y7atG8sxu8uevpfrliB2HuVcrx0=";
  };

  buildInputs = [ poetry ];

  checkInputs = [ hypothesis pytestCheckHook ];

  pythonImportsCheck = [ "expecttest" ];

  meta = {
    maintainers = [ lib.maintainers.SomeoneSerge ];
    license = lib.licenses.mit;
    description = ''EZ Yang "golden" tests (testing against a reference implementation)'';
    homepage = "https://github.com/ezyang/expecttest";
    platforms = lib.platforms.unix;
  };
}
