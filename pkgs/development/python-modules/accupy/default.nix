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
  version = "0.3.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "36506aca53154528997ac22aee6292c83da0f4850bb375c149512b5284bd4948";
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
