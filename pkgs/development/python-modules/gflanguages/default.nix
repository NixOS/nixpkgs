{ lib
, buildPythonPackage
, fetchPypi
, protobuf
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
, uharfbuzz
, youseedee
}:

buildPythonPackage rec {
  pname = "gflanguages";
  version = "5.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AGXpg9EhwdhrcbdcHqz2v9TLaWH1F5gr0QhSuEN2GDA=";
  };

  # Relax the dependency on protobuf 3. Other packages in the Google Fonts
  # ecosystem have begun upgrading from protobuf 3 to protobuf 4,
  # so we need to use protobuf 4 here as well to avoid a conflict
  # in the closure of fontbakery. It seems to be compatible enough.
  pythonRelaxDeps = [
    "protobuf"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    protobuf
  ];

  nativeCheckInputs = [
    pythonRelaxDepsHook
    pytestCheckHook
    uharfbuzz
    youseedee
  ];

  meta = with lib; {
    description = "Python library for Google Fonts language metadata";
    homepage = "https://github.com/googlefonts/lang";
    changelog = "https://github.com/googlefonts/lang/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
