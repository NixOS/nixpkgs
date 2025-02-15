{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
  six,
  stdenv,
}:

buildPythonPackage rec {
  pname = "more-itertools";
  version = "10.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LNf60QCcMcyftqA1EIUJ5lR1R6enODdPEL1JoJ6z7js=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  # iterable = range(10 ** 10)  # Is efficiently reversible
  # OverflowError: Python int too large to convert to C long
  doCheck = !stdenv.hostPlatform.is32bit;

  meta = with lib; {
    homepage = "https://more-itertools.readthedocs.org";
    changelog = "https://more-itertools.readthedocs.io/en/stable/versions.html";
    description = "Expansion of the itertools module";
    license = licenses.mit;
    maintainers = [ ];
  };
}
