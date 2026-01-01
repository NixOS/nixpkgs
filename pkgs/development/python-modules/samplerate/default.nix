{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  setuptools,
  setuptools-scm,
  pybind11,

  # dependencies
  cffi,
  numpy,

  # native dependencies
  libsamplerate,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "samplerate";
<<<<<<< HEAD
  version = "0.2.3";
=======
  version = "0.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tuxu";
    repo = "python-samplerate";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7FAdIqsYCapmEAYiAuoS5m/jFExXZX3hn3kwxn9NWEc=";
=======
    hash = "sha256-aSlnPwFNZRffDsLqhYD1Pd5JOwvv9GcWyseZmeyrvt0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    # unvendor pybind11, libsamplerate
    rm -r external
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(external)" "find_package(pybind11 REQUIRED)"
  '';

  build-system = [
    cmake
    setuptools
    setuptools-scm
    pybind11
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [ libsamplerate ];

  propagatedBuildInputs = [
    cffi
    numpy
  ];

  pythonImportsCheck = [ "samplerate" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf samplerate
  '';

<<<<<<< HEAD
  meta = {
    description = "Python bindings for libsamplerate based on CFFI and NumPy";
    homepage = "https://github.com/tuxu/python-samplerate";
    changelog = "https://github.com/tuxu/python-samplerate/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "Python bindings for libsamplerate based on CFFI and NumPy";
    homepage = "https://github.com/tuxu/python-samplerate";
    changelog = "https://github.com/tuxu/python-samplerate/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
