{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
  protobuf,
  pythonRelaxDepsHook,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "axisregistry";
  version = "0.4.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-obpjiX86fzokao7UWQUXgarKYRNdxplr6/r2D2d7DCI=";
  };

  propagatedBuildInputs = [
    fonttools
    protobuf
  ];
  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  doCheck = true;
  nativeCheckInputs = [ pytestCheckHook ];

  # Relax the dependency on protobuf 3. Other packages in the Google Fonts
  # ecosystem have begun upgrading from protobuf 3 to protobuf 4,
  # so we need to use protobuf 4 here as well to avoid a conflict
  # in the closure of fontbakery. It seems to be compatible enough.
  pythonRelaxDeps = [ "protobuf" ];

  meta = with lib; {
    description = "Google Fonts registry of OpenType variation axis tags";
    homepage = "https://github.com/googlefonts/axisregistry";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
