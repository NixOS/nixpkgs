{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  boost,
  cgal,
  cmake,
  gmp,
  tbb,
  LAStools,
  eigen,
  mpfr,
  numpy,
  swig,
  zlib,
  withLAS ? false, # unfree
}:

buildPythonPackage rec {
  pname = "cgal";
  version = "6.0.post202410011635";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CGAL";
    repo = "cgal-swig-bindings";
    rev = "refs/tags/v${version}";
    hash = "sha256-KXcXykL/m+A5dCDc+f8j7GgVeQahAOaZ/+LLKHyqbS4=";
  };

  dontUseCmakeConfigure = true;

  build-system = [
    setuptools
    cmake
    swig
  ];

  buildInputs =
    [
      cgal
      gmp
      mpfr
      boost
      zlib
      tbb
      eigen
    ]
    ++ lib.optionals withLAS [
      LAStools
    ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "CGAL" ];

  postFixup = lib.optionalString stdenv.hostPlatform.isElf ''
    mv $out/${python.sitePackages}/{lib,CGAL/_lib}
    for file in $out/${python.sitePackages}/CGAL/_*.so; do
      patchelf "$file" --add-rpath $out/${python.sitePackages}/CGAL/_lib
    done
  '';

  checkPhase = ''
    runHook preCheck
    (cd examples/python/
      bash ./test.sh
      cat error.txt
      if grep -qi ' run error$' <error.txt; then
        false
      fi
    )
    runHook postCheck
  '';

  meta = {
    description = "CGAL bindings using SWIG";
    homepage = "https://github.com/CGAL/cgal-swig-bindings";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbsds ];
    # error: no template named 'unary_function' in namespace 'boost::functional::detail'
    broken = stdenv.hostPlatform.isDarwin;
  };
}
