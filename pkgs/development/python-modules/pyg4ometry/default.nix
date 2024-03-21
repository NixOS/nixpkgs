{ lib
, buildPythonPackage
, python
, fetchFromBitbucket
, gitpython
, antlr4-python3-runtime
, boost
, cgal
, configparser
, cython
, gmp
, matplotlib
, mpfr
, networkx
, pandas
, pybind11
, pypandoc
, root
, scipy
, sympy
, testtools
, vtk
}:

buildPythonPackage rec {
  pname = "pyg4ometry";
  version = "1.0.2";
  format = "pyproject";

  src = fetchFromBitbucket {
    owner = "jairhul";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-27AzL6189Et9alYRdSm+CPT+4VYDMSfY2oPRLdgUOBo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "plat = build_ext.get_platform()+'-'+build_ext.get_python_version()" \
                "plat = build_ext.get_platform()+'-'+sys.implementation.cache_tag" \
      --replace "incPath = findPackage" "#" \
      --replace "libPath = findPackage" "#" \
      --replace 'print("Using include paths : ",incPath)' "" \
      --replace 'print("Using library paths : ",libPath)' "" \
      --replace "libraries = ['mpfr','gmp']," "libraries = ['mpfr','gmp', 'CGAL']," \
      --replace "/opt/local" "/nowhere" \
      --replace "antlr4-python3-runtime==4.7.1" "antlr4-python3-runtime" \
      --replace '"vtk",' "" # requires vtk_9 with VTK_WHEEL_BUILD=ON
  '';

  nativeBuildInputs = [
    gitpython
    cython
    pypandoc
    testtools
  ];
  buildInputs = [
    boost
    cgal
    gmp
    mpfr
    pybind11
  ];
  propagatedBuildInputs = [
    antlr4-python3-runtime
    configparser
    matplotlib
    networkx
    pandas
    scipy
    sympy
    vtk
  ];
  checkInputs = [
    root
  ];

  doCheck = true;
  # gdml fails with git.exc.InvalidGitRepositoryError
  # paraview requires paraview
  preCheck = ''
    substituteInPlace pyg4ometry/test/runTests.py \
      --replace "from gdml                   import GdmlLoadTests" "" \
      --replace "from paraviewExport         import VtkExporter" ""
  '';
  checkPhase = ''
    runHook preCheck

    ${python.interpreter} pyg4ometry/test/runTests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "pyg4ometry" ];

  meta = with lib; {
    description = "A package to create, load, write and visualise solid geometry for particle tracking simulations";
    homepage = "http://www.pp.rhul.ac.uk/bdsim/pyg4ometry/";
    license = with licenses; gpl3Only;
    maintainers = with maintainers; [ veprbl ];
  };
}
