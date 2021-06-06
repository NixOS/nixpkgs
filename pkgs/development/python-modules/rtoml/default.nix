{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-rust
, rustPlatform
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rtoml";
  version = "0.6.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "07bf30if1wmbqjp5n4ib43n6frx8ybyxc9fndxncq7aylkrhd7hy";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "1q082sdac5vm4l3b45rfjp4vppp9y9qhagdjqqfdz8gdhm1k8yyy";
  };

  nativeBuildInputs = with rustPlatform; [
    setuptools-rust
    rust.rustc
    rust.cargo
    cargoSetupHook
  ];

  pythonImportsCheck = [ "rtoml" ];

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    description = "Rust based TOML library for python";
    homepage = "https://github.com/samuelcolvin/rtoml";
    license = licenses.mit;
    maintainers = with maintainers; [ evils ];
  };
}
