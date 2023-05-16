{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = [
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

<<<<<<< HEAD
  # This variable is needed to suppress the "Trace/BPT trap: 5" error in Darwin's checkPhase.
  # Not sure of the details, but we can avoid it by changing the matplotlib backend during testing.
  env.MPLBACKEND = lib.optionalString stdenv.isDarwin "Agg";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
