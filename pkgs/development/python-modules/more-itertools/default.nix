{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
, six
, stdenv
}:

buildPythonPackage rec {
  pname = "more-itertools";
  version = "9.0.0";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WmJX5Ah47wUgsYA5kOPiIwOkG1cUAGwyo/2DBLJuoas=";
  };

  nativeBuildInouts = [
    flit-core
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # iterable = range(10 ** 10)  # Is efficiently reversible
  # OverflowError: Python int too large to convert to C long
  doCheck = !stdenv.hostPlatform.is32bit;

  meta = with lib; {
    homepage = "https://more-itertools.readthedocs.org";
    changelog = "https://more-itertools.readthedocs.io/en/stable/versions.html";
    description = "Expansion of the itertools module";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
