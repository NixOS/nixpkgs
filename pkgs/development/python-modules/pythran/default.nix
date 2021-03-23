{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestrunner
, ply
, networkx
, decorator
, gast
, six
, numpy
, beniget
, pytestCheckHook
, scipy
, isPy3k
}:

buildPythonPackage rec {
  pname = "pythran";
  version = "0.9.8post3";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "pythran";
    rev = version;
    sha256 = "sha256-GCWjJlf7zpFzELR6wTF8FoJzJ3F/WdT1hHjY5A5h/+4=";
  };

  nativeBuildInputs = [
    pytestrunner
  ];

  propagatedBuildInputs = [
    ply
    networkx
    decorator
    gast
    six
    numpy
    beniget
  ];

  pythonImportsCheck = [
    "pythran"
    "pythran.backend"
    "pythran.middlend"
    "pythran.passmanager"
    "pythran.toolchain"
    "pythran.spec"
  ];

  checkInputs = [
    pytestCheckHook
    numpy
    scipy
  ];

  # Test suite is huge.
  # Also, in the future scipy will rely on it resulting in a circular test dependency
  doCheck = false;

  disabled = !isPy3k;

  meta = {
    description = "Ahead of Time compiler for numeric kernels";
    homepage = https://github.com/serge-sans-paille/pythran;
    license = lib.licenses.bsd3;
  };

}
