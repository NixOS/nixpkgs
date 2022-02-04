{ lib
, buildPythonPackage
, fetchPypi
, rustPlatform
, rustc
, cargo
, setuptools-rust
# build inputs
, cffi
, glean-parser
}:

buildPythonPackage rec {
  pname = "glean-sdk";
  version = "43.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9LLE7cUJhJ+0/rFtVkSdiXUohrXW0JFy3XcYMAAivfw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256:1qi7zn2278jpry466w3xj1wpyy5f82bffi55i6nva591i3r1z4am";
  };

  nativeBuildInputs = [
    rustc
    cargo
    setuptools-rust
    rustPlatform.cargoSetupHook
  ];
  propagatedBuildInputs = [
    cffi
    glean-parser
  ];

  pythonImportsCheck = [ "glean" ];

  meta = with lib; {
    description = "Modern cross-platform telemetry client libraries and are a part of the Glean project";
    homepage = "https://mozilla.github.io/glean/book/index.html";
    license = licenses.mpl20;
    maintainers = [ maintainers.kvark ];
  };
}
