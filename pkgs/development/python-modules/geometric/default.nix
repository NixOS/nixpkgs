{ buildPythonPackage
, lib
, fetchFromGitHub
, networkx
, numpy
, scipy
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "geometric";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "leeping";
    repo = "geomeTRIC";
    rev = version;
    hash = "sha256-y8dh4vZ/d1KL1EpDrle8CH/KIDMCKKZdAyJVgUFjx/o=";
  };

  patches = [
    ./ase-is-optional.patch
  ];

  propagatedBuildInputs = [
    networkx
    numpy
    scipy
    six
  ];

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Geometry optimization code for molecular structures";
    homepage = "https://github.com/leeping/geomeTRIC";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.markuskowa ];
  };
}

