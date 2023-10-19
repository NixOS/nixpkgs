{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "oldest-supported-numpy";
  version = "2023.8.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yJp+wzsihagnI3crGPDBo+CqbVO4Xhxulj/o/NitxU0=";
  };

  # The purpose of oldest-supported-numpy is to build a project against the
  # oldest version of numpy for a given Python distribution in order to build
  # a binary that is compatible with the largest possible versons of numpy.
  # We only build against one version of numpy in nixpkgs, so instead we only
  # want to make sure that we have a version above the minimum.
  #
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace 'numpy==' 'numpy>='
  '';

  propagatedBuildInputs = [
    numpy
  ];

  # package has no tests
  doCheck = false;

  meta = with lib; {
    description = "Meta-package providing the oldest supported Numpy for a given Python version and platform";
    homepage = "https://github.com/scipy/oldest-supported-numpy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ tjni ];
  };
}
