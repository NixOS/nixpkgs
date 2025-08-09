{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  six,
  stdenv,
}:

buildPythonPackage rec {
  pname = "more-itertools";
  version = "10.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "more-itertools";
    repo = "more-itertools";
    tag = "v${version}";
    hash = "sha256-4ZzuWVRrihhEoYRDAoYLZINR11iHs0sXF/bRm6gQoEA=";
  };

  build-system = [ flit-core ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  # iterable = range(10 ** 10)  # Is efficiently reversible
  # OverflowError: Python int too large to convert to C long
  doCheck = !stdenv.hostPlatform.is32bit;

  meta = with lib; {
    homepage = "https://more-itertools.readthedocs.org";
    changelog = "https://more-itertools.readthedocs.io/en/stable/versions.html";
    description = "Expansion of the itertools module";
    downloadPage = "https://github.com/more-itertools/more-itertools";
    license = licenses.mit;
    maintainers = [ ];
  };
}
