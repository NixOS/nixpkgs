{ lib
, buildPythonPackage
, fetchPypi
, swig
, libfann
}:

let
  pname = "fann2";
  version = "1.1.2";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zcoKZa1I4IMgZyr/44w91OoV4ngh5eHbn6KzQpm91B4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "  find_fann()" "  # find_fann()" \
      --replace "= find_swig()" "= '${swig}/bin/swig'"
  '';

  nativeBuildInputs = [
    swig
  ];

  buildInputs = [
    libfann.dev
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "fann2"
  ];

  meta = with lib; {
    description = "Fast Artificial Neural Network Library (FANN) Python bindings";
    homepage = "https://github.com/FutureLinkCorporation/fann2";
    license = licenses.lgpl2Plus;
    maintainers = teams.mycroft.members;
  };
}
