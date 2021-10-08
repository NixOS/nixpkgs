{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, mpmath
, numpy
, pybind11
, pyfma
, eigen
, importlib-metadata
, pytestCheckHook
, matplotlib
, dufte
, isPy27
}:

buildPythonPackage rec {
  pname = "accupy";
  version = "0.3.6";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad408f2937c22a0628fa8a73856e813c825064a14240cbfd64337d2a45a756c3";
  };

  nativeBuildInputs = [
    pybind11
  ];

  buildInputs = [
    eigen
  ];

  propagatedBuildInputs = [
    mpmath
    numpy
    pyfma
  ] ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  checkInputs = [
    pytestCheckHook
    matplotlib
    dufte
  ];

  postConfigure = ''
   substituteInPlace setup.py \
     --replace "/usr/include/eigen3/" "${eigen}/include/eigen3/"
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # performance tests aren't useful to us and disabling them allows us to
  # decouple ourselves from an unnecessary build dep
  preCheck = ''
    for f in test/test*.py ; do
      substituteInPlace $f --replace 'import perfplot' ""
    done
  '';
  disabledTests = [ "test_speed_comparison1" "test_speed_comparison2" ];
  pythonImportsCheck = [ "accupy" ];

  meta = with lib; {
    description = "Accurate sums and dot products for Python";
    homepage = "https://github.com/nschloe/accupy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
