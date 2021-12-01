{ lib
, buildPythonPackage
, fetchFromGitHub
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
, perfplot
}:

buildPythonPackage rec {
  pname = "accupy";
  version = "0.3.6";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = version;
    sha256 = "0sxkwpp2xy2jgakhdxr4nh1cspqv8l89kz6s832h05pbpyc0n767";
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
    perfplot
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
