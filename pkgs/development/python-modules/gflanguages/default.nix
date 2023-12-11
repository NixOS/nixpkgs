{ lib
, buildPythonPackage
, fetchPypi
, protobuf
, setuptools-scm
, pythonRelaxDepsHook
, pytestCheckHook
, uharfbuzz
, youseedee
}:

buildPythonPackage rec {
  pname = "gflanguages";
  version = "0.5.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JVeI7TlJjbKCa+gGmjylbNiEhX3qmpbLXiH3VpFqgXc=";
  };

  propagatedBuildInputs = [
    protobuf
  ];
  nativeBuildInputs = [
    setuptools-scm
  ];

  doCheck = true;
  nativeCheckInputs = [
    pythonRelaxDepsHook
    pytestCheckHook
    uharfbuzz
    youseedee
  ];

  # Relax the dependency on protobuf 3. Other packages in the Google Fonts
  # ecosystem have begun upgrading from protobuf 3 to protobuf 4,
  # so we need to use protobuf 4 here as well to avoid a conflict
  # in the closure of fontbakery. It seems to be compatible enough.
  pythonRelaxDeps = [ "protobuf" ];

  meta = with lib; {
    description = "Python library for Google Fonts language metadata";
    homepage = "https://github.com/googlefonts/lang";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
