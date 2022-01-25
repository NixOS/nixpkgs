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
  version = "42.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-X2p6KQnEB6ZHdCHGFVEoEMiI+0R2vfGqel+jFKTcx74=";
  };

  patches = [
    # Fix the environment for spawned process
    # https://github.com/mozilla/glean/pull/1542
    ./fix-spawned-process-environment.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-/+rKGPYTLovgjTGL2F/pWzlUy1tY207yuJz3Xdhm1hg=";
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
