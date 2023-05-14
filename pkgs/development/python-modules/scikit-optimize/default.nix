{ lib
, isPy27
, buildPythonPackage
, fetchFromGitHub
, fetchpatch2
, matplotlib
, numpy
, scipy
, scikit-learn
, pyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scikit-optimize";
  version = "0.9.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "scikit-optimize";
    repo = "scikit-optimize";
    rev = "v${version}";
    sha256 = "0hsq6pmryimxc275yrcy4bv217bx7ma6rz0q6m4138bv4zgq18d1";
  };

  patches = [
    # https://github.com/scikit-optimize/scikit-optimize/pull/1166
    (fetchpatch2 {
      url = "https://github.com/scikit-optimize/scikit-optimize/pull/1166.patch";
      hash = "sha256-YCxA0IQIFOJ1nZ741lGIcGsFM08HMz80mb3OalGgM/M";
    })
    # https://github.com/scikit-optimize/scikit-optimize/pull/1150
    (fetchpatch2 {
      url = "https://github.com/scikit-optimize/scikit-optimize/pull/1150.patch";
      hash = "sha256-4OL8rIkq5jYn2X7q8RsyyPXPqUvSxFqHcZ/zoiQR/SU=";
    })
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
    scikit-learn
    pyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Sequential model-based optimization toolbox";
    homepage = "https://scikit-optimize.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
