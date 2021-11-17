{ lib
, pkgs
, python3Packages
, rustPlatform
, setuptools-rust
}:

python3Packages.buildPythonPackage rec {
  pname = "glean-sdk";
  version = "42.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-X2p6KQnEB6ZHdCHGFVEoEMiI+0R2vfGqel+jFKTcx74=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-/+rKGPYTLovgjTGL2F/pWzlUy1tY207yuJz3Xdhm1hg=";
  };

  nativeBuildInputs = [
    pkgs.rustc
    pkgs.cargo
    setuptools-rust
    rustPlatform.cargoSetupHook
  ];
  propagatedBuildInputs = with python3Packages; [
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
