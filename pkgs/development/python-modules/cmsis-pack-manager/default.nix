{ lib
, fetchPypi
, rustPlatform
, cffi
, libiconv
, stdenv
, darwin
, buildPythonPackage
, appdirs
, pyyaml
, hypothesis
, jinja2
, pytestCheckHook
, unzip
}:

buildPythonPackage rec {
  pname = "cmsis_pack_manager";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sVfyz9D7/0anIp0bEPp1EJkERDbNJ3dCcydLbty1KsQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "dO4qw5Jx0exwb4RuOhu6qvGxQZ+LayHtXDHZKADLTEI=";
  };

  nativeBuildInputs = [ rustPlatform.cargoSetupHook rustPlatform.maturinBuildHook ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libiconv ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  propagatedBuildInputs = [ appdirs pyyaml ];
  nativeCheckInputs = [ hypothesis jinja2 pytestCheckHook unzip ];

  format = "pyproject";

  preCheck = ''
    unzip $dist/*.whl cmsis_pack_manager/cmsis_pack_manager/native.so
  '';

  disabledTests = [
    # All require DNS.
    "test_pull_pdscs"
    "test_install_pack"
    "test_pull_pdscs_cli"
    "test_dump_parts_cli"
  ];

  meta = with lib; {
    description = "A Rust and Python module for handling CMSIS Pack files";
    homepage = "https://github.com/pyocd/cmsis-pack-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
